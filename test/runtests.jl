using RationalVals
using Test
using Aqua

v(p::Int) = IntegerVal{p}()
v(p::Rational{Int}) = RationalVal{numerator(p),denominator(p)}()

@testset "constructor" begin
    @test_throws ArgumentError RationalVal{0,0}()
end

@testset "boolean" begin
    @test v(0) == 0
    @test v(1) == true
    @test iszero(v(0)) ≡ isone(v(1)) ≡ (v(2) == v(2)) ≡ (v(1 // 2) == v(1 // 2)) ≡ true
    @test iszero(v(1)) ≡ isone(v(0)) ≡ (v(2) == v(1 // 2)) ≡ false
    @test (v(0) < v(1 // 3) < v(1 // 2) < v(1)) ≡ (v(0) ≤ v(1 // 3) ≤ v(1 // 2) ≤ v(1)) ≡ (isless(v(0), v(1))) ≡ (v(1) > v(0)) ≡ (v(1) ≥ v(0)) ≡ true

    @test isfinite(v(0)) ≡ isfinite(v(1)) ≡ isfinite(v(1 // 2)) ≡ true
    @test isfinite(v(1//0)) ≡ false
end

@testset "arithmetic" begin
    @test 2 // 3 - v(1 // 2) ≡ 1 // 6
    @test v(2)^v(1 // 2) ≡ sqrt(2)
    @test div(1, v(1)) ≡ div(v(1), 1) ≡ 1
    @test Base.divgcd(1, v(1)) ≡ Base.divgcd(v(1), 1) ≡ (1, 1)
end

@testset "misc" begin
    @test inv(v(1)) ≡ v(1)
    @test deg2rad(v(0)) ≡ v(0)
    @test min(v(1), v(0)) ≡ v(0)
    @test max(v(1), v(0)) ≡ v(1)
    @test minmax(v(1), v(0)) ≡ (v(0), v(1))
end

@testset "special" begin
    @testset "sin" begin
        @test sin(v(0)) ≡ v(0)
        @test sind(v(90)) ≡ v(1)
        @test sind(v(180)) ≡ v(0)
        @test sinpi(v(1 // 2)) ≡ v(1)
        @test sinpi(v(2)) ≡ v(0)
        @test sinh(v(0)) ≡ v(0)
        @test asin(v(0)) ≡ v(0)
    end
    @testset "cos" begin
        @test cos(v(0)) ≡ v(1)
        @test cosd(v(0)) ≡ v(1)
        @test cosd(v(90)) ≡ v(0)
        @test cospi(v(-1 // 2)) ≡ v(0)
        @test acos(v(1)) ≡ v(0)
    end
    @testset "tan" begin
        @test tan(v(0)) ≡ v(0)
        @test tand(v(45)) ≡ v(1)
        @test tand(v(-180)) ≡ v(0)
        if VERSION >= v"1.10"
            @test tanpi(v(-2)) ≡ v(0)
        end
        @test tanh(v(0)) ≡ v(0)
        @test atan(v(0)) ≡ v(0)
    end
    @testset "sincos" begin
        @test sincos(v(0)) ≡ (v(0), v(1))
        if VERSION >= v"1.3"
            @test sincosd(v(360)) ≡ (v(0), v(1))
        end
        if VERSION >= v"1.6"
            @test sincospi(v(-2)) ≡ (v(0), v(1))
        end
    end
    @testset "exp/log" begin
        @test exp(v(0)) ≡ v(1)
        @test log(v(1)) ≡ v(0)
        @test log(-1, v(1)) ≡ v(0)
        @test log2(v(1)) ≡ v(0)
        @test log10(v(1)) ≡ v(0)
        @test log1p(v(0)) ≡ v(0)
    end
    @testset "misc" begin
        @test sinc(v(0)) ≡ v(1)
        @test cosc(v(0)) ≡ v(0)
    end
end

@testset "range" begin
    @test v(1):v(5) isa TypedEndsStepRange{Int,IntegerVal{1},IntegerVal{1},IntegerVal{5}}
    @test v(1):5 isa TypedEndsStepRange{Int,IntegerVal{1},IntegerVal{1},Int}
    @test 1:v(5) isa TypedEndsStepRange{Int,Int,IntegerVal{1},IntegerVal{5}}
    @test Base.oneto(v(5)) ≡ v(1):v(5)

    r = v(1):v(5)
    @test length(r) ≡ v(5)
    @test 2 * r ≡ r * 2 ≡ 2:2:10
    @test v(2) * r ≡ r * v(2) ≡ v(2):v(2):v(10)
    @test v(0) * r isa ConstRange{IntegerVal{0}}

    @test v(1 // 2):5 ≡ v(1 // 2):9//2

    @test AbstractArray{Int}(v(0)*r) isa ConstRange{Int}

    r = 1.0:v(1//2):5
    @test r isa TypedEndsStepRange{Float64,Float64,RationalVal{1,2},Float64}
    @test axes(r) ≡ (Base.OneTo(9),)

    r = v(1//2):v(3)
    @test last(r) ≡ v(5//2)
    @test eltype(r) ≡ Rational{Int}
end

@static if VERSION >= v"1.9"
    @testset "extensions" begin
        @testset "Infinities" begin
            using Infinities, InfiniteArrays

            @test IntegerVal{1}():∞ isa TypedEndsStepRange{Int,IntegerVal{1},IntegerVal{1},InfiniteCardinal{0}}
            @test IntegerVal{1}():ℵ₀ isa TypedEndsStepRange{Int,IntegerVal{1},IntegerVal{1},InfiniteCardinal{0}}

            r = IntegerVal{1}():∞
            @test r[1] ≡ 1
            @test r[2] ≡ 2
            @test first(r) ≡ IntegerVal{1}()
            @test last(r) ≡ ℵ₀
            @test r[1:10] ≡ 1:10
            @test r[IntegerVal{1}()] ≡ IntegerVal{1}()
            @test InfiniteArrays.MemoryLayout(r) ≡ InfiniteArrays.LazyLayout()

            @test fld(RealInfinity(), v(1 // 2)) ≡ RealInfinity()
            @test v(1 // 2) * Base.oneto(∞) isa TypedEndsStepRange{Rational{Int},RationalVal{1,2},RationalVal{1,2},RealInfinity}

            @test v(0) * ∞ ≡ v(0) * ℵ₀ ≡ v(0) * (-∞) ≡ v(0)

            r = v(1//2):∞
            @test eltype(r) ≡ Rational{Int}
        end
        @testset "IrrationalConstants" begin
            using IrrationalConstants
            for (a, b) in ((quartπ, halfπ), (halfπ, π), (π, twoπ), (twoπ, fourπ), (inv4π, inv2π), (inv2π, invπ), (invπ, twoinvπ), (twoinvπ, fourinvπ), (sqrthalfπ, sqrt2π), (sqrtπ, sqrt4π), (invsqrt2, sqrt2))
                @test a * v(2) ≡ v(2) * a ≡ b
                @test b * v(1 // 2) ≡ v(1 // 2) * b ≡ b / v(2) ≡ a
                @test a / b ≡ v(1 // 2)
                @test b / a ≡ v(2)
            end
            for (a, b) in ((quartπ, π), (halfπ, twoπ), (π, fourπ), (inv4π, invπ), (inv2π, twoinvπ), (invπ, fourinvπ))
                @test a * v(4) ≡ v(4) * a ≡ b
                @test b * v(1 // 4) ≡ v(1 // 4) * b ≡ b / v(4) ≡ a
                @test a / b ≡ v(1 // 4)
                @test b / a ≡ v(4)
            end
            for (a, b) in ((quartπ, twoπ), (halfπ, fourπ), (inv4π, twoinvπ), (inv2π, fourinvπ))
                @test a * v(8) ≡ v(8) * a ≡ b
                @test b * v(1 // 8) ≡ v(1 // 8) * b ≡ b / v(8) ≡ a
                @test a / b ≡ v(1 // 8)
                @test b / a ≡ v(8)
            end
        end
    end
end

@testset "Aqua" begin
    @testset "Aqua" begin
        Aqua.test_all(RationalVals)
    end
end
