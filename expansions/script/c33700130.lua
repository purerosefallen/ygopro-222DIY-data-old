--霓火星童
function c33700130.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c33700130.mfilter1,c33700130.mfilter2,1,63,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c33700130.sprcon)
	e2:SetOperation(c33700130.sprop)
	c:RegisterEffect(e2) 
	 --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c33700130.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone() 
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetCondition(c33700130.indcon2)
	c:RegisterEffect(e4)
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c33700130.atkcon)
	e5:SetValue(c33700130.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetCondition(c33700130.defcon)
	e6:SetValue(c33700130.defval)
	c:RegisterEffect(e5)
end
function c33700130.mfilter1(c)
	return c:IsFusionSetCard(0x443) and c:IsFusionType(TYPE_SYNCHRO)
end
function c33700130.mfilter2(c)
	return c:IsFusionSetCard(0x443) and c:IsType(TYPE_MONSTER)
end
function c33700130.spfilter1(c,tp)
	return c:IsFusionSetCard(0x443) and c:IsFusionType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c33700130.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c33700130.spfilter2(c)
	return c:IsFusionSetCard(0x443) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
end
function c33700130.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-5
		and Duel.IsExistingMatchingCard(c33700130.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c33700130.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c33700130.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.GetMatchingGroup(c33700130.spfilter2,tp,LOCATION_MZONE,0,g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=g2:Select(tp,1,g2:GetCount(),nil)
	g1:Merge(g3)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c33700130.indcon(e)
	return e:GetHandler():GetAttack()<e:GetHandler():GetDefense()
end
function c33700130.indcon2(e)
	return e:GetHandler():GetAttack()>e:GetHandler():GetDefense()
end
function c33700130.atkcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())>Duel.GetLP(1-e:GetHandlerPlayer())
end
function c33700130.atkval(e,c)
	return Duel.GetLP(e:GetHandlerPlayer())-Duel.GetLP(1-e:GetHandlerPlayer())
end
function c33700130.defcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<Duel.GetLP(1-e:GetHandlerPlayer())
end
function c33700130.defval(e,c)
	return Duel.GetLP(1-e:GetHandlerPlayer())-Duel.GetLP(e:GetHandlerPlayer())
end