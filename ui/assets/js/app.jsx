class TaskContainer extends React.Component {
    constructor() {
        super();

        this.addTask = this.addTask.bind(this)
        this.deleteTask = this.deleteTask.bind(this)

        this.state ={
            tasks: [{
                id: 0,
                title: "Loading...",
                completed: false,
                priority: 0
            }]
        };
    }

    componentWillMount() {
        fetch("/api/task/")
        .then(response => response.json())
            .then(data => this.setState({tasks: data}));
    };

    addTask(task) {
        var tasks  = this.state.tasks;
        tasks.push(task);
        this.setState({tasks: tasks});
    }

    deleteTask(task) {

        console.log(task)

        var filteredTasks = this.state.tasks.filter(function (item) {
            return (item.id !== task.id);
          });

        console.log(filteredTasks)

        this.setState({tasks: filteredTasks});

        fetch("/api/task/" + task.id + "/", {
            method: "DELETE",
        })


    }

    render() {

      return (
        <div>
            <h1>To Do</h1>
            <TaskForm onAddTask={this.addTask}/>
            <TaskList tasks={this.state.tasks} delete={this.deleteTask}/>
        </div>
      );
    }
}

class TaskList extends React.Component {
    constructor(props){
        super(props);
    }

    delete(task) {
        this.props.delete(task)
    }

    render() {
        return(
            <ul className="theList">
            {this.props.tasks.map(task =>
                <li key={task.id}><span className="delete" onClick={() => this.delete(task)}><i className="fas fa-trash"></i></span><span className="title">{task.title}</span></li>
            )}
            </ul>
        )
    }
}

class TaskForm extends React.Component {
    constructor(props) {
        super(props);

        this.handleSubmit = this.handleSubmit.bind(this);
    }

    state = {
        title: "",
        priority: 1000,
        completed: false,
        id: 0,
    };

    onChange = (e) => {
        // Because we named the inputs to match their corresponding values in state, it's
        // super easy to update the state
        const state = this.state
        state[e.target.name] = e.target.value;
        this.setState(state);
    }

    handleSubmit(event) {
        event.preventDefault();

        const data = this.state

        console.log(data)

        if (data.Title === "") {
            return;
        }

        fetch('/api/task/', {
          method: 'POST',
          headers: {'Content-Type':'application/json'},
          body: JSON.stringify(data),
        }).then(response => response.json())
        .then(data => this.props.onAddTask(data))
        .then(o => this.setState({Title: ""}));
    }

    render() {
		return (
			<form onSubmit={this.handleSubmit} className="taskForm">
				<input id="Title" name="Title" type="Text" placeholder="title..." onChange={this.onChange} value={this.state.Title}/>
				<button><i className="fas fa-plus"></i></button>
			</form>
		);
	}
}


ReactDOM.render( <TaskContainer/>, document.querySelector("#root"));

