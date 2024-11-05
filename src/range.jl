struct TypedEndsStepRange{T,L,S,R} <: AbstractRange{T}
    start::L
    step::S
    stop::R
end
TypedEndsStepRange{T}(start::L, step::S, stop::R) where {T,L,S,R} = TypedEndsStepRange{T,L,S,R}(start, step, stop)
length(r::TypedEndsStepRange) = fld(r.stop-r.start,r.step)+IntegerVal(1)

_rangestop(start, step, stop)=convert(Integer, fld(stop - start, step))*step + start
_rangestop(::Integer, ::IntegerVal{1}, stop)=floor(Integer, stop)
function _steprange(start, step, stop)
    s = _rangestop(start,step,stop)
    TypedEndsStepRange{promote_type(typeof(start), typeof(step), typeof(s))}(start, step, s)
end
(:)(start::RationalValUnion, step::Real, stop::Real) = _steprange(start, step, stop)
(:)(start::Real, step::RationalValUnion, stop::Real) = _steprange(start, step, stop)
(:)(start::Real, step::Real, stop::RationalValUnion) = _steprange(start, step, stop)
(:)(start::RationalValUnion, stop::Real) = start:IntegerVal(1):stop
(:)(start::Real, stop::RationalValUnion) = start:IntegerVal(1):stop

(:)(start::Real, ::IntegerVal{1}, stop::Real) = start:stop

first(r::TypedEndsStepRange) = r.start
step(r::TypedEndsStepRange) = r.step
last(r::TypedEndsStepRange) = r.stop

unsafe_getindex(r::TypedEndsStepRange{S,<:RationalValUnion}, i::Integer) where {S} = first(r) + step(r) * (i - oneunit(i))

oneto(r::IntegerVal) = IntegerVal(1):r

broadcasted(::DefaultArrayStyle{1}, ::typeof(*), x::Number, r::TypedEndsStepRange) = x*first(r):x*step(r):x*last(r)
broadcasted(::DefaultArrayStyle{1}, ::typeof(*), r::TypedEndsStepRange, x::Number) = first(r)*x:step(r)*x:last(r)*x