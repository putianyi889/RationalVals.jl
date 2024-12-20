module RationalValsInfiniteArraysExt

using InfiniteArrays, RationalVals
import Base: (:)
import Base.Broadcast: broadcasted, DefaultArrayStyle, BroadcastStyle
import InfiniteArrays: InfRanges, RealInfinity, OneToInf, LazyLayout, MemoryLayout, InfiniteCardinal,LazyArrayStyle
import RationalVals: _first, _step, _steprange

_first(::OneToInf) = IntegerVal{1}()

const InfRangeFromRationalVal = Union{<:TypedEndsStepRange{<:Any,<:Any,<:Any,<:Union{InfiniteCardinal{0},RealInfinity}},<:ConstRange{<:Any,RealInfinity}}

MemoryLayout(::Type{<:InfRangeFromRationalVal}) = LazyLayout()
BroadcastStyle(::Type{<:InfRangeFromRationalVal}) = LazyArrayStyle{1}()

# ambiguities
(:)(start::Real, step::RationalValUnion, stop::RealInfinity) = _steprange(start, step, stop)
(:)(start::T, step::T, stop::RealInfinity) where {T<:RationalValUnion} = _steprange(start, step, stop)

broadcasted(::DefaultArrayStyle{1}, ::typeof(*), x::RationalValUnion, r::InfRanges) = x*_first(r):x*_step(r):x*last(r)
broadcasted(::DefaultArrayStyle{1}, ::typeof(*), ::IntegerVal{0}, r::InfRanges) = ConstRange(IntegerVal{0}, length(r))

end # module