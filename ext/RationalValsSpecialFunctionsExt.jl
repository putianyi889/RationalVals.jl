module RationalValsSpecialFunctionsExt

using SpecialFunctions, RationalVals
import SpecialFunctions: gamma

gamma(::RationalVal{1,2}) = sqrt(π)

end # module