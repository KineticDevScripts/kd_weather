let playerSettings = {};
let recievedTime = {};

window.addEventListener("message", (event) => {
  const data = event.data;

  if (data.action === "showMenu") {
    document.getElementById("menu-container").style.display = "flex";
  } else if (data.action === "hideMenu") {
    document.getElementById("menu-container").style.display = "none";
  } else if (data.action === "applySettings") {
    applySettings(data.settings);
  } else if (data.action === "getServerData") {
    const data = data.data;
    document.getElementById('current-weather').innerText = data.currentWeather;
    document.getElementById('current-time').innerText = data.currentTime;
  } else if (data.action === "updateCurrent") {
    document.getElementById('current-weather').innerText = data.currentWeather;
    document.getElementById('current-time').innerText = data.currentTime;
  }
});

document.addEventListener("keydown", function (event) {
  if (event.key === "Escape") {
      closeMenu()
  }
});

document.addEventListener("DOMContentLoaded", function () {
  fetchServerData();
});

function closeMenu() {
  fetch(`https://${GetParentResourceName()}/closeMenu`, { method: "POST" });
}

function openTab(tabId) {
  const tabs = document.querySelectorAll(".tab");
  tabs.forEach((tab) => tab.classList.remove("active"));
  document.getElementById(tabId).classList.add("active");

  if (tabId === 'dashboard') {
    fetchServerData();  
  }
}

// Dashboard tab

function updateTimeSlider(time) {
  document.getElementById('slider-time').innerText = time + ":00";
  recievedTime = time
}

function manualSetTime() {
  if (recievedTime) {
    fetch(`https://${GetParentResourceName()}/manualSetTime`, {
      method: "POST",
      body: JSON.stringify({ time: recievedTime })
    });
  } else {
    console.log('Error fetching time')
  }
}

function fetchServerData() {
  fetch(`https://${GetParentResourceName()}/getServerData`, {
    method: 'POST',
    body: JSON.stringify({ action: 'getServerData' })
  }).then(response => response.json()).then(data => {
    document.getElementById('current-weather').innerText = data.currentWeather;
    document.getElementById('current-time').innerText = data.currentTime;
  }).catch(err => {
    console.error('Error fetching server data:', err);
  });
}

function freezeWeather() {
  fetch(`https://${GetParentResourceName()}/freezeWeather`, {
    method: "POST",
  });
}

function freezeTime() {
  fetch(`https://${GetParentResourceName()}/freezeTime`, {
    method: "POST",
  });
}

function setMorning() {
  fetch(`https://${GetParentResourceName()}/setMorning`, {
    method: "POST",
  });
}

function setNoon() {
  fetch(`https://${GetParentResourceName()}/setNoon`, {
    method: "POST",
  });
}

function setEvening() {
  fetch(`https://${GetParentResourceName()}/setEvening`, {
    method: "POST",
  });
}

function setNight() {
  fetch(`https://${GetParentResourceName()}/setNight`, {
    method: "POST",
  });
}

function setExtraSunny() {
  fetch(`https://${GetParentResourceName()}/setExtraSunny`, {
    method: "POST",
  });
}

function setClear() {
  fetch(`https://${GetParentResourceName()}/setClear`, {
    method: "POST",
  });
}

function setNeutral() {
  fetch(`https://${GetParentResourceName()}/setNeutral`, {
    method: "POST",
  });
}

function setSmog() {
  fetch(`https://${GetParentResourceName()}/setSmog`, {
    method: "POST",
  });
}

function setFoggy() {
  fetch(`https://${GetParentResourceName()}/setFoggy`, {
    method: "POST",
  });
}

function setOvercast() {
  fetch(`https://${GetParentResourceName()}/setOvercast`, {
    method: "POST",
  });
}

function setClouds() {
  fetch(`https://${GetParentResourceName()}/setClouds`, {
    method: "POST",
  });
}

function setClearing() {
  fetch(`https://${GetParentResourceName()}/setClearing`, {
    method: "POST",
  });
}

function setRain() {
  fetch(`https://${GetParentResourceName()}/setRain`, {
    method: "POST",
  });
}

function setThunder() {
  fetch(`https://${GetParentResourceName()}/setThunder`, {
    method: "POST",
  });
}

function setSnow() {
  fetch(`https://${GetParentResourceName()}/setSnow`, {
    method: "POST",
  });
}

function setBlizzard() {
  fetch(`https://${GetParentResourceName()}/setBlizzard`, {
    method: "POST",
  });
}

function setSnowLight() {
  fetch(`https://${GetParentResourceName()}/setSnowLight`, {
    method: "POST",
  });
}

function setXmas() {
  fetch(`https://${GetParentResourceName()}/setXmas`, {
    method: "POST",
  });
}

// End Dashboard tab

// Settings Tab
function updatePrimaryColor(color) {
  document.querySelector(".sidebar").style.backgroundColor = color;
  document.querySelector(".close-button").style.backgroundColor = color;
  document.querySelector(".edit-pos-button").style.backgroundColor = color;
  document.querySelector(".save-pos-button").style.backgroundColor = color;
  document.querySelector(".dashboard-header").style.borderBottom = `6px solid ${color}`;
  document.querySelector(".settings-header").style.borderBottom = `6px solid ${color}`;

  document.querySelectorAll("[class^='dashboard-btn']").forEach(btn => {
    btn.style.background = color;
  });

  playerSettings.primaryColor = color;
  saveSettingsToServer();
}

function updateSecondaryColor(color) {
    document.querySelector(".sidebar-header").style.borderBottom = `6px solid ${color}`;
    document.querySelector(".menu").style.backgroundColor = color;
    document.querySelector(".dashboard").style.backgroundColor = color;
    document.querySelector(".settings").style.backgroundColor = color;

    document.querySelectorAll("[class^='dashboard-btn']").forEach(btn => {
      btn.style.border = `3px solid ${color}`;
      btn.style.boxShadow = `0px 0px 10px ${color}`;
    });

    document.querySelector(".edit-pos-button").style.border = `3px solid ${color}`;
    document.querySelector(".edit-pos-button").style.boxShadow = `0px 0px 10px ${color}`;

    document.querySelector(".save-pos-button").style.border = `3px solid ${color}`;
    document.querySelector(".save-pos-button").style.boxShadow = `0px 0px 10px ${color}`;

    playerSettings.secondaryColor = color;
    saveSettingsToServer();
}

function updateMenuSize(size) {
  document.getElementById("menu-container").style.width = size + "%";
  document.getElementById("menu-container").style.height = size + "%";
  document.getElementById("menu-size").value = size;

  playerSettings.menuSize = size;
  saveSettingsToServer();
}

function enableDragMode() {
    const menu = document.getElementById("menu-container");
  
    menu.style.cursor = "move";
    menu.onmousedown = (e) => {
      const shiftX = e.clientX - menu.getBoundingClientRect().left;
      const shiftY = e.clientY - menu.getBoundingClientRect().top;
  
      function moveAt(pageX, pageY) {
        menu.style.left = pageX - shiftX + "px";
        menu.style.top = pageY - shiftY + "px";
      }
  
      function onMouseMove(event) {
        moveAt(event.pageX, event.pageY);
      }
  
      document.addEventListener("mousemove", onMouseMove);
  
      menu.onmouseup = () => {
        document.removeEventListener("mousemove", onMouseMove);
        menu.onmouseup = null;
  
        const position = menu.getBoundingClientRect();
        playerSettings.menuPosition = { top: position.top, left: position.left };
  
        // Enable the "Save Position" button
        document.getElementById("save-position-btn").hidden = false;
      };
    };
  
    menu.ondragstart = () => false;
  }
  
  function savePosition() {
    const menu = document.getElementById("menu-container");
  
    // Disable dragging
    menu.style.cursor = "default";
    menu.onmousedown = null;
  
    saveSettingsToServer();
  
    // Disable the "Save Position" button after saving
    document.getElementById("save-position-btn").hidden = true;
  }

function applySettings(settings) {
  playerSettings = settings;
  document.querySelector(".sidebar").style.backgroundColor = settings.primaryColor;
  document.querySelector(".sidebar-header").style.borderBottom = `6px solid ${settings.secondaryColor}`;
  document.querySelector(".dashboard-header").style.borderBottom = `6px solid ${settings.primaryColor}`;
  document.querySelector(".close-button").style.backgroundColor = settings.primaryColor;
  document.querySelector(".dashboard").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".settings").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".settings-header").style.borderBottom = `6px solid ${settings.primaryColor}`;

  document.querySelectorAll("[class^='dashboard-btn']").forEach(btn => {
    btn.style.background = settings.primaryColor;
    btn.style.border = `3px solid ${settings.secondaryColor}`;
    btn.style.boxShadow = `0px 0px 10px ${settings.secondaryColor}`;
  });

  document.querySelector(".menu").style.backgroundColor = settings.secondaryColor;
  document.querySelector(".edit-pos-button").style.backgroundColor = settings.primaryColor;
  document.querySelector(".save-pos-button").style.backgroundColor = settings.primaryColor;

  document.querySelector(".edit-pos-button").style.border = `3px solid ${settings.secondaryColor}`;
  document.querySelector(".edit-pos-button").style.boxShadow = `0px 0px 10px ${settings.secondaryColor}`;

  document.querySelector(".save-pos-button").style.border = `3px solid ${settings.secondaryColor}`;
  document.querySelector(".save-pos-button").style.boxShadow = `0px 0px 10px ${settings.secondaryColor}`;

  document.getElementById("menu-container").style.height = settings.menuSize + "%";
  document.getElementById("menu-container").style.width = settings.menuSize + "%";

  document.getElementById("menu-size").value = settings.menuSize;

  const menu = document.getElementById("menu-container");
  menu.style.top = settings.menuPosition.top + "px";
  menu.style.left = settings.menuPosition.left + "px";
}

function saveSettingsToServer() {
  fetch(`https://${GetParentResourceName()}/savePlayerSettings`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(playerSettings),
  });
}