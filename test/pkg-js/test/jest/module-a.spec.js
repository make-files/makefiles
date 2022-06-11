const { functionA } = require("../../src/module-a.js");

test("functionA()", () => {
  expect(functionA()).toBe("a");
});
