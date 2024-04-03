module RationalValsInfinitiesExt

import Infinities: Infinity, InfiniteCardinal
import RationalVals: TypedEndsUnitRange, IntegerVal
import Base: (:), eltype, show

(:)(p::P, ::Union{Infinity, InfiniteCardinal{0}}) where {P<:IntegerVal} = TypedEndsUnitRange{Int,P,InfiniteCardinal{0}}(p, InfiniteCardinal{0}())

show(io::IO, r::TypedEndsUnitRange) = print(io, r.start, ":", r.stop)

end # module