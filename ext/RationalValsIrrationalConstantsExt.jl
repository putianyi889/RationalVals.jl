module RationalValsIrrationalConstantsExt

using RationalVals, IrrationalConstants
import Base: *, /

for (v, w) in ((quartπ, halfπ), (halfπ, π), (π, twoπ), (twoπ, fourπ), (inv4π, inv2π), (inv2π, invπ), (invπ, twoinvπ), (twoinvπ, fourinvπ), (sqrthalfπ, sqrt2π), (sqrtπ, sqrt4π), (invsqrt2, sqrt2))
    @eval *(::typeof($v), ::IntegerVal{2}) = $w
    @eval *(::IntegerVal{2}, ::typeof($v)) = $w
    @eval *(::typeof($w), ::RationalVal{1,2}) = $v
    @eval *(::RationalVal{1,2}, ::typeof($w)) = $v
    @eval /(::typeof($v), ::typeof($w)) = RationalVal{1,2}()
    @eval /(::typeof($w), ::typeof($v)) = IntegerVal{2}()
end

for (v, w) in ((quartπ, π), (halfπ, twoπ), (π, fourπ), (inv4π, invπ), (inv2π, twoinvπ), (invπ, fourinvπ))
    @eval *(::typeof($v), ::IntegerVal{4}) = $w
    @eval *(::IntegerVal{4}, ::typeof($v)) = $w
    @eval *(::typeof($w), ::RationalVal{1,4}) = $v
    @eval *(::RationalVal{1,4}, ::typeof($w)) = $v
    @eval /(::typeof($v), ::typeof($w)) = RationalVal{1,4}()
    @eval /(::typeof($w), ::typeof($v)) = IntegerVal{4}()
end

for (v, w) in ((quartπ, twoπ), (halfπ, fourπ), (inv4π, twoinvπ), (inv2π, fourinvπ))
    @eval *(::typeof($v), ::IntegerVal{8}) = $w
    @eval *(::IntegerVal{8}, ::typeof($v)) = $w
    @eval *(::typeof($w), ::RationalVal{1,8}) = $v
    @eval *(::RationalVal{1,8}, ::typeof($w)) = $v
    @eval /(::typeof($v), ::typeof($w)) = RationalVal{1,8}()
    @eval /(::typeof($w), ::typeof($v)) = IntegerVal{8}()
end

end # module