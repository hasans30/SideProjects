// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from "vscode";

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
  // Use the console to output diagnostic information (console.log) and errors (console.error)
  // This line of code will only be executed once when your extension is activated
  console.log(
    'Congratulations, your extension "copybreadcrumbs" is now active!'
  );

  // The command has been defined in the package.json file
  // Now provide the implementation of the command with registerCommand
  // The commandId parameter must match the command field in package.json
  let disposable = vscode.commands.registerCommand(
    "extension.copybreadcrumbs",
    async () => {
      // The code you place here will be executed every time your command is executed
      console.log("hello its running");
      var activeEditor = vscode.window.activeTextEditor;
      if (activeEditor !== undefined) {
        vscode.commands
          .executeCommand<vscode.DocumentSymbol[]>(
            "vscode.executeDocumentSymbolProvider",
            activeEditor.document.uri
          )
          .then((symbols: any[] | undefined) => {
            if (symbols !== undefined) {
              for (const variable of symbols) {
                console.log(`${variable.kind}-${variable.name}`);
              }
            }
          });
      }
      // Display a message box to the user
      let text = await vscode.env.clipboard.readText();
      vscode.window.showInformationMessage(`Copy breadcrumbs ${text}`);
    }
  );

  context.subscriptions.push(disposable);
}

function findVars(symbols: vscode.DocumentSymbol[]): vscode.DocumentSymbol[] {
  var vars = symbols.filter(symbol => {
    // return symbol.kind === vscode.SymbolKind.Variable;
    return true;
  });
  return vars.concat(
    symbols
      .map(symbol => findVars(symbol.children))
      .reduce((a, b) => a.concat(b), [])
  );
}

// this method is called when your extension is deactivated
export function deactivate() {}
