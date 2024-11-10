struct TypedEndsStepRange{T,L,S,R} <: AbstractRange{T}
    start::L
    step::S
    stop::R
end
TypedEndsStepRange{T}(start::L, step::S, stop::R) where {T,L,S,R} = TypedEndsStepRange{T,L,S,R}(start, step, stop)
length(r::TypedEndsStepRange) = fld(r.stop - r.start, r.step) + IntegerVal(1)
axes(r::TypedEndsStepRange) = (Base.oneto(length(r)),)
first(r::TypedEndsStepRange) = r.start
step(r::TypedEndsStepRange) = r.step
last(r::TypedEndsStepRange) = r.stop

struct ConstRange{T,L} <: AbstractRange{T}
    value::T
    length::L
end
first(r::ConstRange) = r.value
step(::ConstRange) = IntegerVal{0}()
last(r::ConstRange) = r.value
length(r::ConstRange) = r.length

TypedEndsStepRange{T}(r::TypedEndsStepRange) where {T} = TypedEndsStepRange{T}(r.start, r.step, r.stop)
AbstractRange{T}(r::TypedEndsStepRange) where {T} = TypedEndsStepRange{T}(r)
AbstractRange{T}(r::ConstRange) where {T} = ConstRange(T(r.value), r.length)
AbstractVector{T}(r::Union{TypedEndsStepRange,ConstRange}) where T=AbstractRange{T}(r)

_rangestop(start, step, stop) = convert(Integer, fld(stop - start, step)) * step + start
_rangestop(::Integer, ::IntegerVal{1}, stop) = floor(Integer, stop)
function _steprange(start, step, stop)
    s = _rangestop(start, step, stop)
    TypedEndsStepRange{promote_type(typeof(start), typeof(step), typeof(s))}(start, step, s)
end
(:)(start::RationalValUnion, step::Real, stop::Real) = _steprange(start, step, stop)
(:)(start::Real, step::RationalValUnion, stop::Real) = _steprange(start, step, stop)
(:)(start::Real, step::Real, stop::RationalValUnion) = _steprange(start, step, stop)
(:)(start::RationalValUnion, stop::Real) = start:IntegerVal(1):stop
(:)(start::Real, stop::RationalValUnion) = start:IntegerVal(1):stop

(:)(start::Real, ::IntegerVal{1}, stop::Real) = start:stop

unsafe_getindex(r::TypedEndsStepRange{S,<:RationalValUnion}, i::Integer) where {S} = _first(r) + _step(r) * (i - oneunit(i))

oneto(r::IntegerVal) = IntegerVal(1):r

broadcasted(::DefaultArrayStyle{1}, ::typeof(*), x::Number, r::TypedEndsStepRange) = x*_first(r):x*_step(r):x*last(r)
broadcasted(::DefaultArrayStyle{1}, ::typeof(*), r::TypedEndsStepRange, x::Number) = _first(r)*x:_step(r)*x:last(r)*x
broadcasted(::DefaultArrayStyle{1}, ::typeof(*), x::RationalValUnion, r::AbstractRange) = x*_first(r):x*_step(r):x*last(r)
broadcasted(::DefaultArrayStyle{1}, ::typeof(*), ::IntegerVal{0}, r::AbstractRange) = ConstRange(IntegerVal{0}(), length(r))

_step(r::AbstractRange) = step(r)
_step(::AbstractUnitRange) = IntegerVal{1}()
_first(r::AbstractRange) = first(r)
_first(::Base.OneTo) = IntegerVal{1}()