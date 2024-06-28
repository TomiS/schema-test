open Jest

open Types

let conditionJSON = `
{
  "type": "and",
  "value": [
    {
      "type": "equal",
      "value": [
        "account",
        "1234"        
      ]
    },
    {
      "type": "greater-than",
      "value": [
        "cost-center",
        "1000"        
      ]
    }
  ]
}
`

describe("Rule Condition serialize to match", () => {
  open Expect

  test("rule condition", () => {
    let condition = Condition.Connective({
      operator: And,
      conditions: [
        Condition.Comparison({
          operator: Equal,
          values: ("account", "1234"),
        }),
        Condition.Comparison({
          operator: GreaterThan,
          values: ("cost-center", "1000"),
        }),
      ],
    })

    let result = Js.Json.parseExn(conditionJSON)
    expect(condition->S.serializeOrRaiseWith(Condition.schema))->Expect.toEqual(result)
  })
})

describe("Rule Condition serialize to match", () => {
  open Expect

  test("rule condition", () => {
    let condition = Condition.Connective({
      operator: And,
      conditions: [
        Condition.Comparison({
          operator: Equal,
          values: ("account", "1234"),
        }),
        Condition.Comparison({
          operator: GreaterThan,
          values: ("cost-center", "1000"),
        }),
      ],
    })
    // Simply wrapping the condition inside a normal record makes the whole thing crash
    let data: body = {condition: condition}

    let result = Js.Json.parseExn(
      `
{
  "condition": ${conditionJSON}
}
`,
    )
    expect(data->S.serializeOrRaiseWith(bodySchema))->Expect.toEqual(result)
  })
})
