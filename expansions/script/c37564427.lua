--百慕 空前绝后之妹·梅娅
local m=37564427
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SEASERPENT),2,2)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c)
		return Senya.check_set_prism(c) and e:GetHandler():GetLinkedGroup():IsContains(c)
	end)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function cm.sfilter(c,e,tp,z)
	if z then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,z)
	else
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	local z=e:GetHandler():GetLinkedZone()
	if chk==0 then return z~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,z)>-1 and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),tp,LOCATION_HAND)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not cm.tdtg(e,tp,eg,ep,ev,re,r,rp,0) or not e:GetHandler():IsRelateToEffect(e) then return end
	local z=e:GetHandler():GetLinkedZone()
	local sg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local tg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	local ct=sg:GetCount()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=tg:Select(tp,1,ct,nil)
	local rct=Duel.SendtoHand(g1,nil,REASON_EFFECT)
	local tsg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_HAND,0,nil,e,tp,z)
	if math.min(tsg:GetCount(),rct)==0 or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,z)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=tsg:Select(tp,1,rct,nil)
	local sct=Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP,z)
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Senya.check_set_prism,nil)>1 then
		local rg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
		if rg:GetCount()>0 and Duel.SelectYesNo(tp,m*16+1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local trg=rg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoDeck(trg,nil,2,REASON_EFFECT)
		end
	end
end