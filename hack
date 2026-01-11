<!DOCTYPE html>
<html lang="hi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Live Code Playground - Hack & Edit</title>
    <style>
        /* Page ka basic setup aur reset */
        :root {
            --bg-color: #1e1e2e;
            --panel-bg: #2b2b3b;
            --text-color: #e0e0e0;
            --accent-color: #ff79c6;
            --secondary-accent: #8be9fd;
            --success-color: #50fa7b;
            --font-mono: 'Courier New', Courier, monospace;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden; /* Scrollbar hatane ke liye, layout scroll karega */
        }

        /* Header Styling */
        header {
            background-color: #11111b;
            padding: 15px 20px;
            border-bottom: 2px solid var(--panel-bg);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h1 {
            font-size: 1.2rem;
            color: var(--secondary-accent);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        header .controls button {
            background-color: var(--accent-color);
            color: #111;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 0.9rem;
            transition: transform 0.1s, opacity 0.2s;
        }

        header .controls button:hover {
            opacity: 0.9;
        }

        header .controls button:active {
            transform: scale(0.95);
        }

        header .controls button.reset-btn {
            background-color: #ff5555;
            color: white;
            margin-left: 10px;
        }

        /* Main Layout Container */
        main {
            display: flex;
            flex: 1;
            height: calc(100vh - 60px);
        }

        /* Left Side: Code Editors */
        .editor-container {
            width: 40%;
            display: flex;
            flex-direction: column;
            border-right: 2px solid var(--panel-bg);
            background-color: var(--panel-bg);
        }

        .tab-header {
            display: flex;
            background-color: #11111b;
        }

        .tab-btn {
            flex: 1;
            padding: 10px;
            background: none;
            border: none;
            color: #888;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            font-family: var(--font-mono);
        }

        .tab-btn.active {
            color: var(--secondary-accent);
            border-bottom: 2px solid var(--secondary-accent);
            background-color: var(--panel-bg);
        }

        .code-area-wrapper {
            flex: 1;
            position: relative;
            display: none; /* JS se show hoga */
        }

        .code-area-wrapper.active {
            display: block;
        }

        textarea {
            width: 100%;
            height: 100%;
            background-color: #1e1e2e;
            color: #f8f8f2;
            border: none;
            padding: 15px;
            font-family: var(--font-mono);
            font-size: 14px;
            resize: none;
            outline: none;
            line-height: 1.5;
        }

        /* Scrollbar styling for textareas */
        textarea::-webkit-scrollbar {
            width: 8px;
        }
        textarea::-webkit-scrollbar-thumb {
            background: #444;
            border-radius: 4px;
        }

        /* Right Side: Live Preview */
        .preview-container {
            width: 60%;
            background-color: #ffffff;
            position: relative;
        }

        iframe {
            width: 100%;
            height: 100%;
            border: none;
            display: block;
        }

        .preview-label {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            pointer-events: none;
            z-index: 10;
        }

        /* Status Bar / Console */
        .status-bar {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            background: #11111b;
            color: #888;
            font-size: 0.8rem;
            padding: 5px 10px;
            border-top: 1px solid #333;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            main {
                flex-direction: column;
            }
            .editor-container {
                width: 100%;
                height: 50%;
            }
            .preview-container {
                width: 100%;
                height: 50%;
            }
        }
    </style>
</head>
<body>

    <header>
        <h1>
            <span>&lt;/&gt;</span> Live Hack Tool
        </h1>
        <div class="controls">
            <button id="runBtn">▶ Run Code</button>
            <button id="resetBtn" class="reset-btn">↺ Reset Default</button>
        </div>
    </header>

    <main>
        <!-- Code Editor Section -->
        <section class="editor-container">
            <div class="tab-header">
                <button class="tab-btn active" data-target="html-editor">HTML</button>
                <button class="tab-btn" data-target="css-editor">CSS</button>
                <button class="tab-btn" data-target="js-editor">JS (Functions)</button>
            </div>

            <!-- HTML Editor -->
            <div class="code-area-wrapper active" id="html-wrapper">
                <textarea id="html-editor" spellcheck="false"></textarea>
            </div>

            <!-- CSS Editor -->
            <div class="code-area-wrapper" id="css-wrapper">
                <textarea id="css-editor" spellcheck="false"></textarea>
            </div>

            <!-- JS Editor -->
            <div class="code-area-wrapper" id="js-wrapper">
                <textarea id="js-editor" spellcheck="false"></textarea>
            </div>
        </section>

        <!-- Preview Section -->
        <section class="preview-container">
            <div class="preview-label">Live Preview</div>
            <iframe id="preview-frame"></iframe>
            <div class="status-bar" id="status-bar">Ready to hack...</div>
        </section>
    </main>

    <script>
        // --- Default Code (The Hackable Base) ---
        const defaultHTML = `
<div id="container">
    <h2>Hackable Animation</h2>
    <div id="box"></div>
    <div class="controls">
        <button onclick="toggleAnimation()">Play/Pause</button>
        <button onclick="changeColor()">Change Color</button>
        <button onclick="resetBox()">Reset</button>
    </div>
    <p id="status">Status: Running</p>
</div>
`;

        const defaultCSS = `
body {
    font-family: sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    margin: 0;
    overflow: hidden;
}

#container {
    text-align: center;
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    width: 90%;
    max-width: 400px;
}

#box {
    width: 100px;
    height: 100px;
    background-color: #ff5555;
    margin: 20px auto;
    border-radius: 8px;
    position: relative;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.controls button {
    padding: 8px 12px;
    margin: 5px;
    cursor: pointer;
    border: none;
    border-radius: 4px;
    background-color: #333;
    color: white;
    font-weight: bold;
}

.controls button:hover {
    background-color: #555;
}
`;

        const defaultJS = `
// Yahan par main variables hain
let posX = 0;
let direction = 1; // 1 = Right, -1 = Left
let speed = 2;
let isAnimating = true;
let animationFrameId;
const box = document.getElementById('box');
const statusText = document.getElementById('status');

// --- YE FUNCTION HACK KAREIN ---
// Is function se box move hota hai
// Aap 'speed' ya 'direction' badal kar dekhein
function updatePosition() {
    if (!isAnimating) return;

    posX += speed * direction;

    // Boundary Check (Agar wall se takraye toh wapis mud jaye)
    if (posX > 100 || posX < 0) {
        direction *= -1; // Direction ulta karein
    }

    // CSS Transform use karke box move karein
    box.style.transform = 'translateX(' + posX + 'px)';

    // Loop chalate rahein (60 FPS)
    animationFrameId = requestAnimationFrame(updatePosition);
}

// Animation shuru karne ka function
function startAnimation() {
    if (!animationFrameId) {
        updatePosition();
    }
}

// Animation Rukwane ka function
function stopAnimation() {
    if (animationFrameId) {
        cancelAnimationFrame(animationFrameId);
        animationFrameId = null;
    }
}

// Button se toggle karne ke liye
function toggleAnimation() {
    isAnimating = !isAnimating;
    statusText.innerText = isAnimating ? "Status: Running" : "Status: Paused";
    
    if(isAnimating) {
        startAnimation();
    } else {
        stopAnimation();
    }
}

// Color change karne ka function
function changeColor() {
    // Random color generate karna
    const randomColor = '#' + Math.floor(Math.random()*16777215).toString(16);
    box.style.backgroundColor = randomColor;
}

// Reset function
function resetBox() {
    posX = 0;
    box.style.transform = 'translateX(0px)';
    box.style.backgroundColor = '#ff5555';
    stopAnimation();
    isAnimating = true;
    statusText.innerText = "Status: Reset";
    startAnimation();
}

// Page load hone par shuru karein
startAnimation();
`;

        // --- DOM Elements ---
        const htmlEditor = document.getElementById('html-editor');
        const cssEditor = document.getElementById('css-editor');
        const jsEditor = document.getElementById('js-editor');
        const previewFrame = document.getElementById('preview-frame');
        const runBtn = document.getElementById('runBtn');
        const resetBtn = document.getElementById('resetBtn');
        const tabBtns = document.querySelectorAll('.tab-btn');
        const statusBar = document.getElementById('status-bar');

        // --- Initialization ---
        function init() {
            htmlEditor.value = defaultHTML.trim();
            cssEditor.value = defaultCSS.trim();
            jsEditor.value = defaultJS.trim();
            runCode();
        }

        // --- Core Logic: Code Execution ---
        function runCode() {
            const htmlContent = htmlEditor.value;
            const cssContent = `<style>${cssEditor.value}</style>`;
            const jsContent = `<script>
                // Error handling for inside iframe
                window.onerror = function(msg, url, line) {
                    document.body.style.border = "5px solid red";
                    document.body.innerHTML += "<h4 style='color:red'>Error: " + msg + "</h4>";
                    return false;
                };
                try {
                    ${jsEditor.value}
                } catch (e) {
                    document.body.innerHTML += "<h4 style='color:red'>JS Error: " + e.message + "</h4>";
                }
            <\/script>`;

            const combinedSource = `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    ${cssContent}
                </head>
                <body>
                    ${htmlContent}
                    ${jsContent}
                </body>
                </html>
            `;

            // Iframe ko update karein
            const doc = previewFrame.contentDocument || previewFrame.contentWindow.document;
            doc.open();
            doc.write(combinedSource);
            doc.close();

            updateStatus("Code updated successfully!");
        }

        // --- UI Interactions ---

        // Tab Switching Logic
        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                // Remove active class from all
                document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                document.querySelectorAll('.code-area-wrapper').forEach(w => w.classList.remove('active'));

                // Add active class to clicked
                btn.classList.add('active');
                const targetId = btn.getAttribute('data-target');
                document.getElementById(targetId).parentNode.classList.add('active');
            });
        });

        // Run Button
        runBtn.addEventListener('click', runCode);

        // Reset Button
        resetBtn.addEventListener('click', () => {
            if(confirm('Kya aap code reset karna chahte hain? Apne changes doob jayenge.')) {
                init();
            }
        });

        // Keyboard Shortcut (Ctrl + Enter) to run
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                runCode();
            }
        });

        // Auto-save simulation (Local Storage)
        // Yeh refresh karne par bhi code save rakhega (optional feature)
        function saveToLocal() {
            localStorage.setItem('hack-html', htmlEditor.value);
            localStorage.setItem('hack-css', cssEditor.value);
            localStorage.setItem('hack-js', jsEditor.value);
        }

        // Status bar update
        function updateStatus(msg) {
            statusBar.innerText = msg;
            statusBar.style.color = '#fff';
            setTimeout(() => {
                statusBar.style.color = '#888';
            }, 1000);
        }

        // Start the app
        window.addEventListener('load', init);

    </script>
</body>
</html>
