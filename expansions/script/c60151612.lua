--圆环之理 鹿目圆香
function c60151612.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c60151612.synfilter,aux.NonTuner(c60151612.synfilter2),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_CHAIN_ACTIVATING)
	e11:SetOperation(c60151612.disop)
	c:RegisterEffect(e11)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151612,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c60151612.thtg)
	e1:SetOperation(c60151612.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(60151612,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c60151612.setcon2)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c60151612.setcon3)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,6011612)
	e4:SetCost(c60151612.cost)
	e4:SetCondition(c60151612.spcon)
	e4:SetTarget(c60151612.pentg)
	e4:SetOperation(c60151612.penop)
	c:RegisterEffect(e4)
end
function c60151612.synfilter(c)
	return c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER)
end
function c60151612.synfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60151612.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER)
end
function c60151612.disop(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
	if not e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO then return end
	Duel.Hint(HINT_CARD,0,60151612)
	Duel.Recover(tp,300,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c60151612.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c60151612.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c60151612.dfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60151612.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO 
		and Duel.IsExistingTarget(c60151612.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c60151612.dfilter,tp,0,LOCATION_ONFIELD,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60151612.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if ct>0 then
		Duel.BreakEffect()
		if Duel.GetLP(tp)>=ct*1000 then
			Duel.SetLP(tp,Duel.GetLP(tp)-ct*1000)
		else
			Duel.SetLP(tp,0)
		end
	end
end
function c60151612.setcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60151612.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
end
function c60151612.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c60151612.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151612.cfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60151612.cfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c60151612.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.CheckLocation(tp,LOCATION_SZONE,6)
	local rsc=Duel.CheckLocation(tp,LOCATION_SZONE,7)
	if chk==0 then return lsc or rsc end
end
function c60151612.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end