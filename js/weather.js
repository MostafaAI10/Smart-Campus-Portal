const weatherPanel = document.getElementById("weather");

navigator.geolocation.getCurrentPosition(successCallback, errorCallback);

async function successCallback(position) {
    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;

    await fetch(`http://api.weatherapi.com/v1/current.json?key=c9c06e51b68c4492a1e74112250312&q=${latitude},${longitude}&aqi=no`)
        .then((response) => response.json())
        .then((response) => {
            console.log(response);
            const condition = response.current.condition.text.toLowerCase();
            let weatherClass = "";
            weatherPanel.className = "";
            if (condition.includes("sunny") || condition.includes("clear")) {
                weatherClass = "weather-sunny";
            } else if (condition.includes("cloud")) {
                weatherClass = "weather-cloudy";
            }   else if (condition.includes("rain") || condition.includes("drizzle")) {
                weatherClass = "weather-rainy";
            } else if (condition.includes("snow")) {
                weatherClass = "weather-snowy";
            } else if (condition.includes("thunder")) {
                weatherClass = "weather-thunderstorm";
            }

            weatherPanel.className = weatherClass;
            const conditionElement = document.getElementById("weather-condition");
            conditionElement.innerHTML = `<img src="https:${response.current.condition.icon}" alt="Icon">${response.current.condition.text}`;
            document.getElementById("temperature").textContent = `${response.current.temp_c}°C`    ;
            document.getElementById("feels_like").textContent = `Feels like ${response.current.feelslike_c}°C`;
            document.getElementById("humidity").textContent = `Humidity: ${response.current.humidity}%`;
            document.getElementById("wind").textContent = `Wind: ${response.current.wind_kph} kph`;
        })
        .catch((error) => {
            console.error("Error fetching weather data: ", error)
            weatherPanel.innerHTML = "<p style=\"display:flex; justify-content:center; align-items:center;\">Unable to fetch weather data at this time.</p>";
        });
}

function errorCallback(error) {
    console.error("Error getting location: ", error);
    weatherPanel.innerHTML = "<p style=\"display:flex; justify-content:center; align-items:center;\">Unable to retrieve your location.</p>";
}

