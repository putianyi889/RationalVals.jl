+(::IntegerVal{0}, b::Real) = b
+(a::Real, ::IntegerVal{0}) = a

*(::IntegerVal{1}, b::Real) = b
*(a::Real, ::IntegerVal{1}) = a
*(::IntegerVal{0}, ::Real) = IntegerVal{0}()
*(::Real, ::IntegerVal{0}) = IntegerVal{0}()

^(::IntegerVal{1}, ::Real) = IntegerVal{1}()
^(::IntegerVal{0}, x::Real) = iszero(x)
^(a::Real, ::IntegerVal{1}) = a
^(::Real, ::IntegerVal{0}) = IntegerVal{1}()
^(::IntegerVal{-1}, x::Integer) = isodd(x) ? -one(x) : one(x)

^(a, ::IntegerVal{p}) where {p} = Base.literal_pow(^, a, Val{p}())
^(a::Real, ::RationalVal{1,2}) = sqrt(a)
^(a::Real, ::RationalVal{1,3}) = cbrt(a)
^(a::Real, ::RationalVal{1,4}) = fourthroot(a)

/(::IntegerVal{1}, x::Number) = inv(x)
inv(::IntegerVal{1}) = IntegerVal(1)
inv(::IntegerVal{-1}) = IntegerVal(-1)