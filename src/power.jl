@generated function ^(::IntegerVal{p}, ::IntegerVal{q}) where {p,q}
    if q == 0
        IntegerVal{1}()
    elseif 0 < q ≤ log(p, typemax(Int))
        IntegerVal{p^q}()
    elseif 0 < -q ≤ log(p, typemax(Int))
        RationalVal{1,p^(-q)}()
    else
        throw(OverflowError("::IntegerVal{$p} ^ ::IntegerVal{$q} overflowed"))
    end
end

@generated function ^(::IntegerVal{p}, ::RationalVal{q,r}) where {p,q,r}
    ret = p^(q//r)
    isinteger(ret) ? IntegerVal{Int(ret)}() : ret
end

for func in (:sqrt,:cbrt)
    @eval @generated function $func(::IntegerVal{p}) where p
        ret = $func(p)
        isinteger(ret) ? IntegerVal{Int(ret)}() : ret
    end
    @eval $func(::RationalVal{p,q}) where {p,q} = $func(IntegerVal{p}())/$func(IntegerVal{q}())
end

^(::RationalVal{p1,q1}, r::RationalValUnion) where {p1,q1} = IntegerVal{p1}()^r / IntegerVal{q1}()^r

log(::IntegerVal{1}) = IntegerVal{0}()
log(::Number, ::IntegerVal{1}) = IntegerVal{0}()

log2(p::RationalValUnion) = log(IntegerVal{2}(), p)
log10(p::RationalValUnion) = log(IntegerVal{10}(), p)
log1p(::IntegerVal{0}) = IntegerVal{0}()

exp(::IntegerVal{0}) = IntegerVal{1}()
exp(::IntegerVal{1}) = ℯ
exp2(p::IntegerVal) = IntegerVal{2}()^p

exp10(p::RationalValUnion) = IntegerVal{10}()^p
expm1(::IntegerVal{0}) = IntegerVal{0}()