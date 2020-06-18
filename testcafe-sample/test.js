import { Selector } from "testcafe"; // first import testcafe selectors

fixture`Getting Started`.page // declare the fixture
`http://localhost:8080/abc.html`; // specify the start page

//then create a test and place your code there
test("My first test", async (t) => {
  const activeUsersTile = Selector(
    ".visual visual-kpi allow-deferred-rendering > .kpiVisual"
  );
  await t
    // Use the assertion to check if the actual header text is equal to the expected one
    .expect(activeUsersTile.exists)
    .ok("found signal result");
});
