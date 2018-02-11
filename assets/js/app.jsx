class TaskContainer extends React.Component {


    render() {
      let who = "World";
      return (
        <div>
            <h1> Hello {who}! </h1>
            <TaskList/>
        </div>
      );
    }
  }

  class TaskList extends React.Component {

    constructor(props) {
        super(props);
    
        this.state = {
          tasks: [],
          isLoading: false,
        };
      }

    componentWillMount() {
        this.setState({isLoading: true})
        fetch("/api/task/")
            .then(response => response.json())
            .then(data => this.setState({ tasks: data, isLoading: false}));
    };

    render() {
        var tasks = this.state.tasks;

        return(
            <ul>
            {tasks.map(task => 
                <li> {task.Title}</li>
            )}
            </ul>
        )
    }
  }
  
  ReactDOM.render( <TaskContainer/>, document.querySelector("#root"));
  