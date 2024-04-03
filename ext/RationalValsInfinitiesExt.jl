module RationalValsInfinitiesExt

import Infinities: Infinity, InfiniteCardinal
import RationalVals: TypedEndsUnitRange, IntegerVal
import Base: (:), eltype

(:)(p::P, ::Union{Infinity, InfiniteCardinal{0}}) where {P<:IntegerVal} = TypedEndsUnitRange{Int,P,InfiniteCardinal{0}}(p, InfiniteCardinal{0}())

end # module