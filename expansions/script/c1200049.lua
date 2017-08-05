--LA Da'ath 王國的尚達鳳
function c1200049.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfba),6,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--Overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200049,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1200049.tg)
	e2:SetOperation(c1200049.op)
	c:RegisterEffect(e2)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200049,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1200049.dtg)
	e2:SetOperation(c1200049.dop)
	c:RegisterEffect(e2)
end
function c1200049.olfilter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c1200049.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200049.olfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c1200049.op(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not Duel.IsExistingMatchingCard(c1200049.olfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200049.olfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
	end
end
function c1200049.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and e:GetHandler():GetOverlayCount()>0 end
	SetOperationInfo(0,CATEGORY_DESTROY,0,0,0,0)
end
function c1200049.ffilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1200049.dop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if c:GetOverlayCount()<1 then return false end
	local m=c:GetOverlayCount()
	c:RemoveOverlayCard(tp,1,m,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local n=g:GetCount()
	if not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then return false end
	local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,n,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.BreakEffect()
	if g:IsExists(Card.IsType,1,nil,TYPE_FUSION) and Duel.IsExistingMatchingCard(c1200049.ffilter,tp,LOCATION_HAND,0,1,nil,e,tp) then
		local fg=Duel.SelectMatchingCard(tp,c1200049.ffilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP)
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
		local xg=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.Remove(xg,POS_FACEUP,REASON_EFFECT)
	end
	if g:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local pg=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoHand(pg,nil,REASON_EFFECT)
	end
end