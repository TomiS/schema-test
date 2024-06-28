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

describe("This already succeeds", () => {
  open Expect

  test("rule condition", () => {
    let result = Js.Json.parseExn(conditionJSON)
    expect(condition->S.serializeOrRaiseWith(Condition.schema))->Expect.toEqual(result)
  })
})

describe("This fails but should succeed too", () => {
  open Expect

  test("rule condition", () => {
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
