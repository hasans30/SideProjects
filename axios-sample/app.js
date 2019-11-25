import axios from "axios";

const url = "https://api.weather.gov/alerts/active/area/WA";

axios.get(url).then(res => console.log(res.data));
