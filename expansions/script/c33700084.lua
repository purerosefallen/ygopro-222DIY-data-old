--动物朋友 北之玄武
function c33700084.initial_effect(c)
		--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33700084,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c33700084.xyzcon)
	e0:SetOperation(c33700084.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c33700084.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55935416,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33700084.drcost)
	e1:SetTarget(c33700084.drtg)
	e1:SetOperation(c33700084.drop)
	c:RegisterEffect(e1)
   --
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700084,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c33700084.xyzcon2)
	e4:SetOperation(c33700084.xyzop2)
	e4:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e4)
end
function c33700084.ffilter1(c,tp,g)
   local race=c:GetRace()
	local code=c:GetCode()
   local att=c:GetAttribute()
   return c:IsXyzLevel(g,4) and  c:IsFaceup()  and c:IsCanBeXyzMaterial(g) and  Duel.IsExistingMatchingCard(c33700084.ffilter2,tp,LOCATION_MZONE,0,1,c,race,code,att,g)
end
function c33700084.ffilter2(c,race,code,att,g)
	 return c:IsXyzLevel(g,4) and c:IsFaceup() and  c:GetCode()~=code and c:GetRace()~=race and c:GetAttribute()~=att and c:IsCanBeXyzMaterial(g)
end
function c33700084.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c33700084.ffilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c33700084.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c33700084.ffilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c33700084.ffilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetRace(),g1:GetFirst():GetCode(),g1:GetFirst():GetAttribute(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
   Duel.Overlay(c,g1)
end
function c33700084.ovfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0x442) and c:IsSummonableCard() and  c:IsCanBeXyzMaterial(g)
end
function c33700084.xyzcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c33700084.ovfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c33700084.xyzop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c33700084.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(g1)
   Duel.Overlay(c,g1)
end
function c33700084.indcon(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c33700084.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33700084.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c33700084.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
	 local cg=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,cg)
   if cg:GetClassCount(Card.GetCode)~=cg:GetCount() then
	Duel.SendtoGrave(cg,REASON_EFFECT)
end
   Duel.ShuffleHand(tp)
end