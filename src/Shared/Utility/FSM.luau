local FSM = {}
FSM.__index = FSM

-- C = context, E = events
export type FSM<C, E> = typeof(setmetatable(
	{} :: {
		ctx: C,
		State: State<C, E>,
	},
	FSM
))

export type State<C, E> = {
	Enter: (ctx: C, fsm: FSM<C, E>) -> (),
	Tick: (DeltaTime: number, ctx: C, fsm: FSM<C, E>) -> (),
	OnEvent: (Event: E, ctx: C, fsm: FSM<C, E>) -> (),
	Exit: (ctx: C, fsm: FSM<C, E>) -> (),
}

function FSM.new<C, E>(Initial: State<C, E>, ctx: C): FSM<C, E>
	local self = setmetatable({}, FSM) :: FSM<C, E>
	self.ctx = ctx
	self.State = Initial
	Initial.Enter(ctx, self)

	return self
end

function FSM.GoTo<C, E>(self: FSM<C, E>, next: State<C, E>)
	if self.State == next then
		return
	end
	self.State.Exit(self.ctx, self)
	self.State = next
	self.State.Enter(self.ctx, self)
end

function FSM.Tick<C, E>(self: FSM<C, E>, dt: number)
	self.State.Tick(dt, self.ctx, self)
end

function FSM.Dispatch<C, E>(self: FSM<C, E>, Event: E)
	self.State.OnEvent(Event, self.ctx, self)
end

return FSM
