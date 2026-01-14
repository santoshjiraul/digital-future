<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MovieZone - Download & Stream</title>
    <!-- Icons ke liye FontAwesome use kar rahe hain -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* CSS Variables - Theme Colors */
        :root {
            --primary-color: #e50914; /* Red jaisa Netflix */
            --background-dark: #141414;
            --background-light: #1f1f1f;
            --text-color: #ffffff;
            --text-secondary: #b3b3b3;
            --card-hover: #2b2b2b;
            --nav-height: 70px;
        }

        /* Basic Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--background-dark);
            color: var(--text-color);
            overflow-x: hidden;
        }

        /* Header / Navbar Styling */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 5%;
            height: var(--nav-height);
            background-color: rgba(0,0,0,0.9);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.5);
        }

        .logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 2px;
            cursor: pointer;
        }

        .nav-links {
            display: flex;
            gap: 20px;
            list-style: none;
        }

        .nav-links a {
            color: var(--text-color);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: var(--primary-color);
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            background: #000;
            border: 1px solid #333;
            padding: 8px 15px;
            border-radius: 4px;
            color: white;
            outline: none;
        }

        .search-box i {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        /* Hero Section */
        .hero {
            height: 60vh;
            background: linear-gradient(to top, var(--background-dark), transparent), url('https://picsum.photos/seed/hero1/1920/1080') no-repeat center center/cover;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 0 5%;
            margin-bottom: 20px;
        }

        .hero h1 {
            font-size: 3rem;
            max-width: 600px;
            margin-bottom: 10px;
        }

        .hero p {
            font-size: 1.1rem;
            max-width: 500px;
            margin-bottom: 20px;
            color: #ddd;
        }

        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            font-size: 1rem;
            transition: transform 0.2s, background 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #f40612;
        }

        .btn-secondary {
            background-color: rgba(109, 109, 110, 0.7);
            color: white;
            margin-left: 10px;
        }

        .btn-secondary:hover {
            background-color: rgba(109, 109, 110, 0.4);
        }

        /* Filter Section */
        .categories {
            padding: 0 5%;
            margin-bottom: 20px;
            overflow-x: auto;
            white-space: nowrap;
        }

        .cat-btn {
            background: transparent;
            border: 1px solid var(--text-secondary);
            color: var(--text-secondary);
            padding: 8px 16px;
            border-radius: 20px;
            margin-right: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .cat-btn:hover, .cat-btn.active {
            background: white;
            color: black;
            border-color: white;
        }

        /* Movie Grid */
        .movies-container {
            padding: 0 5% 50px 5%;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .movie-card {
            background-color: var(--background-light);
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
            cursor: pointer;
        }

        .movie-card:hover {
            transform: scale(1.03);
            box-shadow: 0 10px 20px rgba(0,0,0,0.5);
            z-index: 10;
        }

        .poster {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .card-details {
            padding: 15px;
        }

        .card-title {
            font-size: 1rem;
            font-weight: bold;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .card-info {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-bottom: 10px;
        }

        .download-btn {
            width: 100%;
            background: #333;
            color: white;
            border: none;
            padding: 8px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            transition: background 0.3s;
        }

        .download-btn:hover {
            background: var(--primary-color);
        }

        /* Modal / Popup */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background: var(--background-light);
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            text-align: center;
            position: relative;
            box-shadow: 0 0 20px rgba(229, 9, 20, 0.3);
        }

        .close-modal {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--text-secondary);
        }

        .progress-container {
            width: 100%;
            background-color: #333;
            border-radius: 5px;
            margin: 20px 0;
            height: 10px;
            overflow: hidden;
        }

        .progress-bar {
            width: 0%;
            height: 100%;
            background-color: var(--primary-color);
            transition: width 0.2s;
        }

        /* Toast Notification */
        .toast {
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: white;
            padding: 12px 24px;
            border-radius: 50px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            gap: 10px;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s, bottom 0.3s;
            z-index: 3000;
        }

        .toast.show {
            opacity: 1;
            bottom: 50px;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .hero h1 { font-size: 2rem; }
            .nav-links { display: none; } /* Mobile menu simplified for demo */
            .movies-container { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 480px) {
            .movies-container { grid-template-columns: 1fr; }
            .hero { height: 50vh; }
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header>
        <div class="logo"><i class="fas fa-play-circle"></i> MovieZone</div>
        <ul class="nav-links">
            <li><a href="#">Home</a></li>
            <li><a href="#">Movies</a></li>
            <li><a href="#">Web Series</a></li>
            <li><a href="#">My List</a></li>
        </ul>
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Search movies...">
            <i class="fas fa-search"></i>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <h1>The Dark Mountain</h1>
        <p>Ekthriller movie jo aapko seat ke border par baithaye degi. Abhi download karein.</p>
        <div>
            <button class="btn btn-primary" onclick="showToast('Playback Feature Coming Soon')"><i class="fas fa-play"></i> Play Now</button>
            <button class="btn btn-secondary"><i class="fas fa-info-circle"></i> More Info</button>
        </div>
    </section>

    <!-- Filter Categories -->
    <div class="categories">
        <button class="cat-btn active" onclick="filterMovies('All', this)">All</button>
        <button class="cat-btn" onclick="filterMovies('Action', this)">Action</button>
        <button class="cat-btn" onclick="filterMovies('Sci-Fi', this)">Sci-Fi</button>
        <button class="cat-btn" onclick="filterMovies('Drama', this)">Drama</button>
        <button class="cat-btn" onclick="filterMovies('Comedy', this)">Comedy</button>
    </div>

    <!-- Movies Grid -->
    <div class="movies-container" id="movieGrid">
        <!-- JS se yahan movies inject honge -->
    </div>

    <!-- Footer -->
    <footer style="text-align: center; padding: 40px; color: #555; font-size: 0.8rem;">
        <p>&copy; 2023 MovieZone. All rights reserved.</p>
        <p>Disclaimer: This is a demo website. No real files are hosted here.</p>
    </footer>

    <!-- Download Modal -->
    <div class="modal" id="downloadModal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeModal()">&times;</span>
            <h2 id="modalTitle">Downloading...</h2>
            <p id="modalQuality">Quality: 720p | 1.2GB</p>
            
            <div class="progress-container">
                <div class="progress-bar" id="progressBar"></div>
            </div>
            
            <p id="statusText" style="color: var(--text-secondary);">Connecting to server...</p>
        </div>
    </div>

    <!-- Toast Notification -->
    <div class="toast" id="toast">
        <i class="fas fa-check-circle" style="color: #4caf50;"></i>
        <span id="toastMsg">Action Successful</span>
    </div>

    <script>
        // Dummy Movie Data (Placeholders)
        const movies = [
            { id: 1, title: "Cyber Chase", category: "Action", rating: 4.5, year: 2023, img: "https://picsum.photos/seed/cyber/300/450" },
            { id: 2, title: "Love in Paris", category: "Drama", rating: 4.0, year: 2022, img: "https://picsum.photos/seed/love/300/450" },
            { id: 3, title: "Space Odyssey", category: "Sci-Fi", rating: 4.8, year: 2023, img: "https://picsum.photos/seed/space/300/450" },
            { id: 4, title: "Funny Boys", category: "Comedy", rating: 3.9, year: 2021, img: "https://picsum.photos/seed/funny/300/450" },
            { id: 5, title: "The Last Stand", category: "Action", rating: 4.2, year: 2020, img: "https://picsum.photos/seed/action/300/450" },
            { id: 6, title: "Future World", category: "Sci-Fi", rating: 4.6, year: 2024, img: "https://picsum.photos/seed/robot/300/450" },
            { id: 7, title: "Tears of Rain", category: "Drama", rating: 4.1, year: 2019, img: "https://picsum.photos/seed/rain/300/450" },
            { id: 8, title: "Joker Laugh", category: "Comedy", rating: 4.3, year: 2022, img: "https://picsum.photos/seed/laugh/300/450" },
        ];

        const movieGrid = document.getElementById('movieGrid');
        const searchInput = document.getElementById('searchInput');

        // Initial Render
        renderMovies(movies);

        // Function to render movies to HTML
        function renderMovies(data) {
            movieGrid.innerHTML = '';
            
            if(data.length === 0) {
                movieGrid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: #777;">No movies found.</p>';
                return;
            }

            data.forEach(movie => {
                const card = document.createElement('div');
                card.classList.add('movie-card');
                card.innerHTML = `
                    <img src="${movie.img}" alt="${movie.title}" class="poster">
                    <div class="card-details">
                        <h3 class="card-title">${movie.title}</h3>
                        <div class="card-info">
                            <span>${movie.year}</span>
                            <span><i class="fas fa-star" style="color: gold;"></i> ${movie.rating}</span>
                        </div>
                        <button class="download-btn" onclick="startDownload('${movie.title}')">
                            <i class="fas fa-download"></i> Download
                        </button>
                    </div>
                `;
                movieGrid.appendChild(card);
            });
        }

        // Search Functionality
        searchInput.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            const filtered = movies.filter(movie => movie.title.toLowerCase().includes(term));
            renderMovies(filtered);
        });

        // Category Filter
        function filterMovies(category, btnElement) {
            // UI Update
            document.querySelectorAll('.cat-btn').forEach(btn => btn.classList.remove('active'));
            btnElement.classList.add('active');

            // Logic
            if (category === 'All') {
                renderMovies(movies);
            } else {
                const filtered = movies.filter(movie => movie.category === category);
                renderMovies(filtered);
            }
        }

        // Modal Logic
        const modal = document.getElementById('downloadModal');
        const progressBar = document.getElementById('progressBar');
        const statusText = document.getElementById('statusText');

        function startDownload(movieTitle) {
            document.getElementById('modalTitle').innerText = "Downloading: " + movieTitle;
            modal.style.display = 'flex';
            
            let width = 0;
            progressBar.style.width = '0%';
            statusText.innerText = "Connecting to secure server...";

            // Simulation of download progress
            const interval = setInterval(() => {
                if (width >= 100) {
                    clearInterval(interval);
                    statusText.innerText = "Download Complete!";
                    setTimeout(() => {
                        closeModal();
                        showToast(`${movieTitle} Downloaded Successfully!`);
                    }, 1000);
                } else {
                    width += Math.random() * 10; // Random speed
                    if(width > 100) width = 100;
                    progressBar.style.width = width + '%';
                    
                    if(width < 30) statusText.innerText = "Starting download...";
                    else if(width < 70) statusText.innerText = "Downloading content...";
                    else statusText.innerText = "Finalizing...";
                }
            }, 300);
        }

        function closeModal() {
            modal.style.display = 'none';
        }

        // Close modal if clicked outside content
        window.onclick = function(event) {
            if (event.target == modal) {
                closeModal();
            }
        }

        // Toast Notification Function
        function showToast(message) {
            const toast = document.getElementById('toast');
            document.getElementById('toastMsg').innerText = message;
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }

    </script>
</body>
</html>
