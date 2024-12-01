import 'package:flutter/material.dart';

class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();



  @override
  void initState(){
    _foundToDo = todoList;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: _buildAppBar(),

      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal:20,
                vertical: 15 ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Text("All ToDos",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                       ToDoItem(todo: todoo,
                       onToDoChanged: _handleToDoChange,
                         onDeleteItem: _deleteToDoItem,
                       ),

                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(child:
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                  left: 20,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    hintText: "Add a new todo item",
                    border: InputBorder.none,
                  ),
                ),
              ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20),
                child: ElevatedButton(
                    child: Text("+",style: TextStyle(fontSize: 40),),
                  onPressed: (){ _addToDoItem(_todoController.text);},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),

              )
            ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo){
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id){
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }
  void _addToDoItem(String toDo){
    setState(() {
      todoList.add(ToDo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        todoText: toDo,));
    });
    _todoController.clear();
  }

  void _runFilter(enteredKeyword){
    List<ToDo> results=[];
    if( enteredKeyword.isEmpty){
      results = todoList;
    }else{
      results = todoList.where((item) => item.todoText!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search,
            color: Colors.black,
            size: 20,),
          prefixIconConstraints:
          BoxConstraints(maxHeight: 20,minWidth: 25),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),

    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.menu,
                color:Colors.black,
            size: 30,),
            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("x.png"),
              ),
            )
          ],)
    );
  }
}
class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  const ToDoItem({Key? key, required this.todo, required this.onToDoChanged, required this.onDeleteItem }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),

        ),
        contentPadding:EdgeInsets.symmetric(horizontal: 20,vertical: 5) ,
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ?  Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.purple,),
        title: Text(
          todo.todoText!,
          style: TextStyle(fontSize: 16,
            color: Colors.black,
            decoration: todo.isDone? TextDecoration.lineThrough: null,
          ),

        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(todo.id);
            },

          ),
        ),
      ) ,
    );

  }
}
class ToDo{
  String? id;
  String? todoText;
  late bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
});
  static List<ToDo> todoList(){
    return[
      ToDo(id: '01', todoText: "Morning Excercise",isDone: true),
      ToDo(id: '02', todoText: "Eat Brake fast",isDone: true),
      ToDo(id: '03', todoText: "Check Mails",),
      ToDo(id: '04', todoText: "Attending Lectures",),
      ToDo(id: '05', todoText: "Work on Assesments",),
      ToDo(id: '06', todoText: "Play Football",),
    ];
  }
}


