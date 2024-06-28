module Condition = {
  module Connective = {
    type operator = | @as("or") Or | @as("and") And
    type t<'t> = {
      operator: operator,
      conditions: array<'t>,
    }
  }

  module Comparison = {
    module Operator = {
      type t =
        | @as("equal") Equal
        | @as("greater-than") GreaterThan
    }
    type t = {
      operator: Operator.t,
      values: (string, string),
    }
  }

  type rec t =
    | Connective(Connective.t<t>)
    | Comparison(Comparison.t)

  let schema = S.recursive(innerSchema =>
    S.union([
      S.object(s => {
        s.tag("type", "or")
        Connective({operator: Or, conditions: s.field("value", S.array(innerSchema))})
      }),
      S.object(s => {
        s.tag("type", "and")
        Connective({operator: And, conditions: s.field("value", S.array(innerSchema))})
      }),
      S.object(s => {
        s.tag("type", "equal")
        Comparison({
          operator: Equal,
          values: s.field("value", S.tuple2(S.string, S.string)),
        })
      }),
      S.object(s => {
        s.tag("type", "greater-than")
        Comparison({
          operator: GreaterThan,
          values: s.field("value", S.tuple2(S.string, S.string)),
        })
      }),
    ])
  )
}

// This is just a simple wrapper record that causes the error
@schema
type body = {condition: Condition.t}
