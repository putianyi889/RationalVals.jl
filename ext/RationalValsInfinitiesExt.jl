module RationalValsInfinitiesExt

import Infinities: InfiniteCardinal
import RationalVals: IntegerValTo
import Base: (:)

(:)(::IntegerVal{p},x::InfiniteCardinal{0}) = IntegerValTo{IntegerVal{p},InfiniteCardinal{0}}(x)

end # module