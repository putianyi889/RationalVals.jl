module RationalValsInfinitiesExt

import Infinities: Infinity, InfiniteCardinal, RealInfinity
import RationalVals: IntegerVal, _rangestop, RationalValUnion, _steprange, TypedEndsStepRange
import Base: (:), *, promote_rule, getindex, @propagate_inbounds, unsafe_getindex

const PosInfinity = Union{Infinity,InfiniteCardinal{0}}

promote_rule(::Type{<:IntegerVal}, ::Type{<:InfiniteCardinal}) = Integer

*(x::InfiniteCardinal, ::IntegerVal{1}) = x

_rangestop(::Integer, ::IntegerVal, stop::Union{PosInfinity,RealInfinity}) = InfiniteCardinal{0}()

@propagate_inbounds function getindex(r::TypedEndsStepRange, v::AbstractRange{<:Integer})
    @boundscheck checkbounds(r,v)
    unsafe_getindex(r,v)
end
unsafe_getindex(r::TypedEndsStepRange, v::AbstractRange{<:Integer}) = r[first(v)]:r.step*step(v):r[last(v)]
unsafe_getindex(r::TypedEndsStepRange, v::AbstractUnitRange{<:Integer}) = r[first(v)]:r.step:r[last(v)]

# ambiguities
_rangestop(::Integer, ::IntegerVal{1}, stop::Union{PosInfinity,RealInfinity}) = InfiniteCardinal{0}()
(:)(start::RationalValUnion, stop::PosInfinity) = start:IntegerVal(1):stop
(:)(start::RationalValUnion, step::RationalValUnion, stop::PosInfinity) = _steprange(start, step, stop)
(:)(start::RationalValUnion, step::IntegerVal{1}, stop::PosInfinity) = _steprange(start, step, stop)

end # module