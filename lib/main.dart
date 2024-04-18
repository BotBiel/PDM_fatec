import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _navigateToRecuperarSenha(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecuperarSenhaPage()),
    );
  }

  void _login(BuildContext context) {
    if (_emailController.text == "1" && _passwordController.text == "1") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListaCompra()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid email or password"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => _navigateToRecuperarSenha(context),
              child: Text('Esqueceu a Senha?'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecuperarSenhaPage extends StatefulWidget {
  @override
  _RecuperarSenhaPageState createState() => _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState extends State<RecuperarSenhaPage> {
  final _emailController = TextEditingController();

  void _sendRecoveryEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('E-mail de recuperação enviado! Verifique sua caixa de entrada.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esqueceu a Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendRecoveryEmail,
              child: Text('Enviar E-mail de Recuperação'),
            ),
          ],
        ),
      ),
    );
  }
}
class ListaCompra extends StatefulWidget {
  @override
  _ListaCompraState createState() => _ListaCompraState();
}

class _ListaCompraState extends State<ListaCompra> {
  List<Map<String, dynamic>> shoppingLists = [];
  final TextEditingController _listNameController = TextEditingController();
void _showAddListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nova Lista de Compras"),
          content: TextField(
            controller: _listNameController,
            decoration: InputDecoration(hintText: "Nome da Lista"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); 
                _listNameController.clear(); 
              },
            ),
            TextButton(
              child: Text("Criar"),
              onPressed: () {
                if (_listNameController.text.isNotEmpty) {
                  _addNewList(_listNameController.text);
                  Navigator.of(context).pop(); 
                  _listNameController.clear(); 
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewList(String listName) {
    setState(() {
      shoppingLists.add({
        "name": listName,
        "items": [],
      });
    });
  }

  void _editListName(int index, String newListName) {
    setState(() {
      shoppingLists[index]["name"] = newListName;
    });
  }

  void _deleteList(int index) {
    setState(() {
      shoppingLists.removeAt(index);
    });
  }

  void _addItemToList(int listIndex, String itemName, int quantity) {
    setState(() {
      shoppingLists[listIndex]["items"].add({"name": itemName, "quantity": quantity, "purchased": false});
    });
  }

  void _editItemInList(int listIndex, int itemIndex, String newName, int newQuantity) {
    setState(() {
      shoppingLists[listIndex]["items"][itemIndex]["name"] = newName;
      shoppingLists[listIndex]["items"][itemIndex]["quantity"] = newQuantity;
    });
  }

  void _deleteItemFromList(int listIndex, int itemIndex) {
    setState(() {
      shoppingLists[listIndex]["items"].removeAt(itemIndex);
    });
  }

  void _toggleItemPurchased(int listIndex, int itemIndex) {
    setState(() {
      shoppingLists[listIndex]["items"][itemIndex]["purchased"] = !shoppingLists[listIndex]["items"][itemIndex]["purchased"];
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(shoppingLists[index]['name']),
            subtitle: Text('Items: ${shoppingLists[index]['items'].length}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteList(index),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListDetailsPage(list: shoppingLists[index])),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddListDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListDetailsPage extends StatefulWidget {
  final Map<String, dynamic> list;

  ListDetailsPage({required this.list});

  @override
  _ListDetailsPageState createState() => _ListDetailsPageState();
}

class _ListDetailsPageState extends State<ListDetailsPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();

  void _showAddOrEditItemDialog({int? itemIndex}) {
    bool isEditing = itemIndex != null;
    if (isEditing) {
      _itemNameController.text = widget.list['items'][itemIndex]['name'];
      _itemQuantityController.text = widget.list['items'][itemIndex]['quantity'].toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? "Editar Item" : "Adicionar Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  hintText: "Nome do Item",
                ),
                autofocus: true,
              ),
              TextField(
                controller: _itemQuantityController,
                decoration: const InputDecoration(
                  hintText: "Quantidade",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); 
                _clearTextFields();
              },
            ),
            TextButton(
              child: Text(isEditing ? "Salvar" : "Adicionar"),
              onPressed: () {
                if (_itemNameController.text.isNotEmpty && _itemQuantityController.text.isNotEmpty) {
                  if (isEditing) {
                    _editItemInList(itemIndex!, _itemNameController.text, int.parse(_itemQuantityController.text));
                  } else {
                    _addItemToList(_itemNameController.text, int.parse(_itemQuantityController.text));
                  }
                  Navigator.of(context).pop(); 
                  _clearTextFields();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addItemToList(String name, int quantity) {
    setState(() {
      widget.list['items'].add({
        "name": name,
        "quantity": quantity,
        "purchased": false,
      });
    });
  }

  void _editItemInList(int index, String newName, int newQuantity) {
    setState(() {
      widget.list['items'][index] = {
        "name": newName,
        "quantity": newQuantity,
        "purchased": widget.list['items'][index]['purchased']
      };
    });
  }

  void _deleteItemFromList(int index) {
    setState(() {
      widget.list['items'].removeAt(index);
    });
  }

  void _clearTextFields() {
    _itemNameController.clear();
    _itemQuantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list['name']),
      ),
      body: ListView.builder(
        itemCount: widget.list['items'].length,
        itemBuilder: (context, index) {
          var item = widget.list['items'][index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Quantidade: ${item['quantity']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showAddOrEditItemDialog(itemIndex: index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteItemFromList(index),
                ),
                IconButton(
                  icon: Icon(
                    item['purchased'] ? Icons.check_box : Icons.check_box_outline_blank,
                    color: item['purchased'] ? Colors.green : null,
                  ),
                  onPressed: () {
                    setState(() {
                      item['purchased'] = !item['purchased'];
                    });
                  },
                ),
              ],
            ),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditItemDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
