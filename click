<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Click for Points!</title>
  <style>
    body {
      margin: 0;
      overflow: hidden;
      background: #121212;
      color: white;
      font-family: sans-serif;
      user-select: none;
    }

    #scoreboard {
      position: fixed;
      top: 10px;
      left: 10px;
      font-size: 20px;
      z-index: 1000;
      display: none;
    }

    .button {
      position: absolute;
      width: 60px;
      height: 60px;
      background: #00bcd4;
      color: white;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      font-size: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.2s ease, opacity 0.3s ease;
    }

    .button:hover {
      background: #0097a7;
    }

    .shake {
      animation: shake 0.5s ease infinite;
    }

    @keyframes shake {
      0% { transform: translateX(0); }
      25% { transform: translateX(-5px); }
      50% { transform: translateX(5px); }
      75% { transform: translateX(-5px); }
      100% { transform: translateX(5px); }
    }

    #menu {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
    }

    .difficulty-button {
      background: #2196f3;
      border: none;
      color: white;
      padding: 15px 30px;
      margin: 10px;
      font-size: 18px;
      cursor: pointer;
      border-radius: 10px;
    }

    .difficulty-button:hover {
      background: #1976d2;
    }

    #shop {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background-color: rgba(0, 0, 0, 0.8);
      padding: 40px;
      border-radius: 10px;
      display: none;
      width: 300px;
      text-align: center;
    }

    #shop h2 {
      color: white;
      font-size: 24px;
      margin-bottom: 20px;
    }

    .shop-item {
      background-color: #00bcd4;
      color: white;
      border: none;
      padding: 10px;
      margin: 10px;
      font-size: 16px;
      border-radius: 5px;
      cursor: pointer;
      width: 100%;
    }

    .shop-item:hover {
      background: #0097a7;
    }

    .shop-button {
      position: fixed;
      top: 10px;
      right: 10px;
      background-color: #2196f3;
      color: white;
      padding: 10px 20px;
      border: none;
      font-size: 18px;
      cursor: pointer;
      border-radius: 10px;
    }

    .shop-button:hover {
      background: #1976d2;
    }

  </style>
</head>
<body>

<div id="scoreboard">Score: 0</div>

<div id="menu">
  <h1>Choose Difficulty</h1>
  <button class="difficulty-button" onclick="startGame('easy')">Easy</button>
  <button class="difficulty-button" onclick="startGame('medium')">Medium</button>
  <button class="difficulty-button" onclick="startGame('hard')">Hard</button>
</div>

<button class="shop-button" onclick="openShop()">Open Shop</button>

<div id="shop">
  <h2>Shop</h2>
  <button class="shop-item" onclick="buyUpgrade('size')">Upgrade Button Size (150 points)</button>
  <button class="shop-item" onclick="buyUpgrade('color')">Change Button Color (200 points)</button>
  <button class="shop-item" onclick="buyUpgrade('animation')">Button Animation (30 points)</button>
  <button class="shop-item" onclick="buyUpgrade('autoclick')">Auto-Clicker (200,000 points)</button>
  <button class="shop-item" onclick="closeShop()">Close Shop</button>
</div>

<script>
  let score = 0;
  let spawnSpeed;
  let buttonSize = 60;
  let buttonColor = "#00bcd4";
  let buttonShape = 'circle'; 
  let buttonAnimation = false;
  let autoClickerEnabled = false;
  let createdButtons = [];
  const scoreboard = document.getElementById("scoreboard");

  const difficultySpeeds = {
    easy: 2000,
    medium: 1200,
    hard: 500
  };

  // Start the game based on the chosen difficulty
  function startGame(difficulty) {
    spawnSpeed = difficultySpeeds[difficulty];
    document.getElementById("menu").style.display = "none";
    scoreboard.style.display = "block";
    createRandomButton();
    if (autoClickerEnabled) {
      startAutoClicker();
    }
  }

  // Create random buttons at intervals
  function createRandomButton() {
    const button = document.createElement("button");
    button.classList.add("button");
    button.innerText = "🎯";

    const size = buttonSize;
    const x = Math.random() * (window.innerWidth - size);
    const y = Math.random() * (window.innerHeight - size);
    button.style.left = `${x}px`;
    button.style.top = `${y}px`;
    button.style.width = `${size}px`;
    button.style.height = `${size}px`;
    button.style.backgroundColor = buttonColor;

    // Introduce an extremely rare chance (0.000000000000000000000000000000000000000000000000000000000000009) for the button to turn rainbow
    const rareChance = Math.random();
    if (rareChance < 9e-59) {  // Extremely small chance (0.000000000000000000000000000000000000000000000000000000000000009)
      button.style.background = 'linear-gradient(45deg, red, orange, yellow, green, blue, indigo, violet)';
      button.innerText = "🌈";
      button.onclick = () => {
        score += 2000000000000; // Add 2 trillion points
        alert('Congratulations! You won 2 trillion points!');
        button.remove();
        scoreboard.innerText = `Score: ${score}`;
      };
    } else {
      // Regular button behavior
      button.onclick = () => {
        score++;
        scoreboard.innerText = `Score: ${score}`;
        button.remove();
      };
    }

    if (buttonAnimation) {
      button.classList.add('shake');
    }

    createdButtons.push(button); // Add button to the list of created buttons

    const timeout = setTimeout(() => {
      button.remove();
    }, 2000);

    document.body.appendChild(button);

    setTimeout(createRandomButton, spawnSpeed);
  }

  // Shop functionality
  function openShop() {
    document.getElementById("shop").style.display = "block";
  }

  function closeShop() {
    document.getElementById("shop").style.display = "none";
  }

  // Buy upgrades in the shop
  function buyUpgrade(type) {
    if (type === 'size' && score >= 150) {
      score -= 150;
      buttonSize += 10;
      alert('Button size upgraded!');
    } else if (type === 'color' && score >= 200) {
      score -= 200;
      buttonColor = "#ff4081";
      alert('Button color changed!');
    } else if (type === 'animation' && score >= 30) {
      score -= 30;
      buttonAnimation = true;
      alert('Button animation enabled!');
    } else if (type === 'autoclick' && score >= 200000) {
      score -= 200000;
      autoClickerEnabled = true;
      alert('Auto-Clicker purchased!');
    } else {
      alert('Not enough points!');
    }
    scoreboard.innerText = `Score: ${score}`;
  }

  // Function for auto-clicker
  function startAutoClicker() {
    setInterval(() => {
      if (createdButtons.length > 0) {
        const randomButton = createdButtons[Math.floor(Math.random() * createdButtons.length)];
        randomButton.click(); // Automatically click a random created button
      }
    }, 100); // Click every 100ms
  }
</script>

</body>
</html>
