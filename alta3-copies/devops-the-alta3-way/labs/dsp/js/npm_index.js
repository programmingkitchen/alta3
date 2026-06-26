const axios = require('axios');

axios.get('http://api.open-notify.org/astros.json')
    .then(response => {                             //both of these methods ".then" and ".catch" are chained to the ".get()",            
        console.log(response.data);                 //but on the next line for readability. 
    })
    .catch(error => {
        console.log(error);
    });
