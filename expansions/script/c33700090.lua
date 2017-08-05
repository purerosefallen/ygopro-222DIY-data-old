--Nice to Meet You, Japari Park!
function c33700090.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33700090.operation)
	c:RegisterEffect(e1)
	--self
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c33700090.sgcon)
	e3:SetOperation(c33700090.sgop)
	c:RegisterEffect(e3)
   --to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c33700090.thcost)
	e4:SetTarget(c33700090.thtg)
	e4:SetOperation(c33700090.thop)
	c:RegisterEffect(e4)
end
function c33700090.operation(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():RegisterFlagEffect(33700090,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c33700090.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetFlagEffect(33700090)~=0 
end
function c33700090.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c33700090.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c33700090.thfilter(c)
	return c:IsSetCard(0x442)  and c:IsAbleToHand()
end
function c33700090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700090.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c33700090.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700090.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end