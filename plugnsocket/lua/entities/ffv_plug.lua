AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Spawnable = true
ENT.PrintName = "Plug"
ENT.Category = "Plugs & Sockets"
ENT.Instructions = "Goes with socket"

ENT.socket = nil
ENT.socketWeld = nil
ENT.ply = nil

function ENT:Initialize()
	if CLIENT then return end
	self:SetModel("models/props_lab/tpplug.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():SetMass(0)

	self:SetUseType(SIMPLE_USE)
end

function ENT:PostEntityPaste(ply,ent,ents)
	--reset vars
	self.socket = nil
	self.socketWeld = nil
	self.ply = nil

	--destroy plug related welds
	timer.Simple(.01,function()
		--timer here is probably not good but constraints arent created yet when postentitypaste is called
		if (not IsValid(self)) then return end

		for k,v in pairs(constraint.FindConstraints(self,"Weld")) do
			if ((v.Ent1==self) or (v.Ent2==self)) then
				for k1,v1 in pairs(constraint.FindConstraints(v.Ent2,"Weld")) do
					if (((v1.Ent1==v.Ent2) or (v1.Ent2==v.Ent2)) and (v1.forcelimit==-8)) then v1.Constraint:Remove() end
				end
				if (v.forcelimit==-8) then v.Constraint:Remove() end
			end
		end
	end)
end

if CLIENT then return end
hook.Add("OnPhysgunPickup","ffvPhysgunPlug",function(ply,ent) ent.ply = ply end)
hook.Add("GravGunOnPickedUp","ffvGravgunPlug",function(ply,ent) ent.ply = ply end)