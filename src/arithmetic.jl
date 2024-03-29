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