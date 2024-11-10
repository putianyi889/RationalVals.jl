module RationalValsInfinitiesExt

import Infinities: Infinity, InfiniteCardinal, RealInfinity
import RationalVals: IntegerVal, _rangestop, RationalValUnion, _steprange, TypedEndsStepRange
import Base: (:), *, promote_rule, getindex, @propagate_inbounds, unsafe_getindex, fld

const PosInfinity = Union{Infinity,InfiniteCardinal{0}}

fld(x::RealInfinity, y::RationalValUnion) = y ≥ IntegerVal{0}() ? x : -x

promote_rule(::Type{<:IntegerVal}, ::Type{<:InfiniteCardinal}) = Integer

_rangestop(::Integer, ::IntegerVal, stop::Union{PosInfinity,RealInfinity}) = InfiniteCardinal{0}()

@propagate_inbounds function getindex(r::TypedEndsStepRange, v::AbstractRange{<:Integer})
    @boundscheck checkbounds(r, v)
    unsafe_getindex(r, v)
end
unsafe_getindex(r::TypedEndsStepRange, v::AbstractRange{<:Integer}) = r[first(v)]:r.step*step(v):r[last(v)]
unsafe_getindex(r::TypedEndsStepRange, v::AbstractUnitRange{<:Integer}) = r[first(v)]:r.step:r[last(v)]

# ambiguities
*(::IntegerVal{0}, ::Infinity) = IntegerVal{0}()
*(::IntegerVal{0}, ::RealInfinity) = IntegerVal{0}()
*(::IntegerVal{0}, ::InfiniteCardinal) = IntegerVal{0}()
*(x::InfiniteCardinal, ::IntegerVal{1}) = x

_rangestop(::Integer, ::IntegerVal{1}, stop::Union{PosInfinity,RealInfinity}) = InfiniteCardinal{0}()

(:)(start::RationalValUnion, stop::PosInfinity) = start:IntegerVal(1):stop
(:)(start::RationalValUnion, step::RationalValUnion, stop::PosInfinity) = _steprange(start, step, stop)
(:)(start::RationalValUnion, step::IntegerVal{1}, stop::PosInfinity) = _steprange(start, step, stop)

end # module