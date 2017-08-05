--巨大战舰 泡核（D）
function c13257214.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,1)
	e1:SetCondition(c13257214.spcon)
	e1:SetOperation(c13257214.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c13257214.retcon)
	e2:SetOperation(c13257214.retop)
	c:RegisterEffect(e2)
	--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCost(c13257214.spcost)
	e3:SetOperation(c13257214.spcop)
	c:RegisterEffect(e3)
	
end
function c13257214.spfilter(c,ft)
	return c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c13257214.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c13257214.spfilter,tp,0,LOCATION_MZONE,1,nil,ft)
end
function c13257214.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13257214.spfilter,tp,0,LOCATION_MZONE,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13257214.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function c13257214.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13257214.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c13257214.splimit(e,c)
	return not c:IsSetCard(0x15)
end
function c13257214.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()~=e:GetHandler():GetOwner()
end
function c13257214.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	c:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetValue(c:GetOwner())
	e1:SetReset(RESET_EVENT+0xec0000)
	c:RegisterEffect(e1)
end