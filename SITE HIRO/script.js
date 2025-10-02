// ===================================
// SITE PORTFÓLIO HIRO
// JavaScript Completo
// ===================================

// Estado Global
const state = {
    currentSection: 'inicio',
    isLoggedIn: false,
    currentUser: null,
    visitedSections: new Set(),
    achievements: {
        explorer: false,
        reader: false,
        konami: false
    },
    konamiCode: [],
    konamiSequence: ['ArrowUp', 'ArrowUp', 'ArrowDown', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowLeft', 'ArrowRight', 'b', 'a']
};

// ===================================
// SISTEMA DE PARTÍCULAS
// ===================================

class ParticleSystem {
    constructor() {
        this.canvas = document.getElementById('particles');
        this.ctx = this.canvas.getContext('2d');
        this.particles = [];
        this.particleCount = 50;
        
        this.resize();
        this.init();
        this.animate();
        
        window.addEventListener('resize', () => this.resize());
    }
    
    resize() {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
    }
    
    init() {
        for (let i = 0; i < this.particleCount; i++) {
            this.particles.push({
                x: Math.random() * this.canvas.width,
                y: Math.random() * this.canvas.height,
                size: Math.random() * 3 + 1,
                speedX: (Math.random() - 0.5) * 0.5,
                speedY: (Math.random() - 0.5) * 0.5,
                opacity: Math.random() * 0.5 + 0.2
            });
        }
    }
    
    animate() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        this.particles.forEach(particle => {
            // Atualizar posição
            particle.x += particle.speedX;
            particle.y += particle.speedY;
            
            // Wraparound
            if (particle.x < 0) particle.x = this.canvas.width;
            if (particle.x > this.canvas.width) particle.x = 0;
            if (particle.y < 0) particle.y = this.canvas.height;
            if (particle.y > this.canvas.height) particle.y = 0;
            
            // Desenhar partícula
            this.ctx.fillStyle = `rgba(196, 30, 58, ${particle.opacity})`;
            this.ctx.beginPath();
            this.ctx.arc(particle.x, particle.y, particle.size, 0, Math.PI * 2);
            this.ctx.fill();
        });
        
        requestAnimationFrame(() => this.animate());
    }
}

// ===================================
// NAVEGAÇÃO
// ===================================

class Navigation {
    constructor() {
        this.nav = document.getElementById('main-nav');
        this.hamburger = document.querySelector('.hamburger');
        this.navMenu = document.querySelector('.nav-menu');
        this.navLinks = document.querySelectorAll('.nav-link');
        
        this.init();
    }
    
    init() {
        // Scroll spy
        window.addEventListener('scroll', () => {
            this.handleScroll();
        });
        
        // Menu mobile
        this.hamburger.addEventListener('click', () => {
            this.navMenu.classList.toggle('active');
        });
        
        // Links
        this.navLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                const href = link.getAttribute('href');
                if (href.startsWith('#')) {
                    e.preventDefault();
                    const section = document.querySelector(href);
                    if (section) {
                        section.scrollIntoView({ behavior: 'smooth' });
                        this.navMenu.classList.remove('active');
                    }
                }
            });
        });
    }
    
    handleScroll() {
        // Adicionar background ao scroll
        if (window.scrollY > 100) {
            this.nav.style.background = 'rgba(10, 10, 10, 0.98)';
        } else {
            this.nav.style.background = 'rgba(10, 10, 10, 0.95)';
        }
        
        // Rastrear seções visitadas
        document.querySelectorAll('.section').forEach(section => {
            const rect = section.getBoundingClientRect();
            if (rect.top < window.innerHeight / 2 && rect.bottom > window.innerHeight / 2) {
                const sectionId = section.id;
                if (!state.visitedSections.has(sectionId)) {
                    state.visitedSections.add(sectionId);
                    this.checkExplorerAchievement();
                }
            }
        });
    }
    
    checkExplorerAchievement() {
        if (state.visitedSections.size >= 4 && !state.achievements.explorer) {
            unlockAchievement('explorer');
        }
    }
}

// ===================================
// PARALLAX HERO
// ===================================

class ParallaxHero {
    constructor() {
        this.layers = document.querySelectorAll('.mountain-layer');
        this.init();
    }
    
    init() {
        window.addEventListener('mousemove', (e) => {
            const mouseX = e.clientX / window.innerWidth;
            const mouseY = e.clientY / window.innerHeight;
            
            this.layers.forEach((layer, index) => {
                const speed = (index + 1) * 20;
                const x = (mouseX - 0.5) * speed;
                const y = (mouseY - 0.5) * speed;
                
                layer.style.transform = `translate(${x}px, ${y}px)`;
            });
        });
    }
}

// ===================================
// BOTÃO EXPLORAR
// ===================================

document.getElementById('explore-btn')?.addEventListener('click', () => {
    document.getElementById('portfolio').scrollIntoView({ behavior: 'smooth' });
});

// ===================================
// ANIMAÇÃO DE STATS
// ===================================

class StatsAnimator {
    constructor() {
        this.stats = document.querySelectorAll('.stat-number');
        this.animated = false;
        this.init();
    }
    
    init() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && !this.animated) {
                    this.animateStats();
                    this.animated = true;
                }
            });
        });
        
        document.querySelectorAll('.stats').forEach(el => observer.observe(el));
    }
    
    animateStats() {
        this.stats.forEach(stat => {
            const target = parseInt(stat.dataset.target);
            const duration = 2000;
            const increment = target / (duration / 16);
            let current = 0;
            
            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    current = target;
                    clearInterval(timer);
                    if (!state.achievements.reader) {
                        unlockAchievement('reader');
                    }
                }
                stat.textContent = Math.floor(current);
            }, 16);
        });
    }
}

// ===================================
// ANIMAÇÃO DE SKILLS
// ===================================

class SkillsAnimator {
    constructor() {
        this.skills = document.querySelectorAll('.skill-progress');
        this.animated = false;
        this.init();
    }
    
    init() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && !this.animated) {
                    this.animateSkills();
                    this.animated = true;
                }
            });
        });
        
        document.querySelectorAll('.skills-section').forEach(el => observer.observe(el));
    }
    
    animateSkills() {
        this.skills.forEach(skill => {
            const progress = skill.dataset.progress;
            setTimeout(() => {
                skill.style.width = progress + '%';
            }, 100);
        });
    }
}

// ===================================
// SISTEMA DE PORTFÓLIO
// ===================================

const portfolioData = [
    {
        id: 1,
        title: 'E-commerce Minimalista',
        category: 'web',
        description: 'Loja online com design clean inspirado no minimalismo japonês',
        image: 'https://via.placeholder.com/400x300/c41e3a/ffffff?text=E-commerce',
        technologies: ['React', 'Node.js', 'MongoDB'],
        link: '#'
    },
    {
        id: 2,
        title: 'Ilustração Digital - Yokai',
        category: 'art',
        description: 'Série de ilustrações de criaturas do folclore japonês',
        image: 'https://via.placeholder.com/400x300/d4af37/ffffff?text=Yokai+Art',
        technologies: ['Photoshop', 'Procreate'],
        link: '#'
    },
    {
        id: 3,
        title: 'Game Engine 2D',
        category: 'code',
        description: 'Motor de jogo 2D desenvolvido em Python',
        image: 'https://via.placeholder.com/400x300/4a4a4a/ffffff?text=Game+Engine',
        technologies: ['Python', 'Pygame', 'OpenGL'],
        link: '#'
    },
    {
        id: 4,
        title: 'Dashboard Analytics',
        category: 'web',
        description: 'Painel de análise de dados com visualizações interativas',
        image: 'https://via.placeholder.com/400x300/c41e3a/ffffff?text=Dashboard',
        technologies: ['Vue.js', 'D3.js', 'Firebase'],
        link: '#'
    },
    {
        id: 5,
        title: 'Motion Graphics - Torii',
        category: 'art',
        description: 'Animação 3D de portal torii com efeitos de partículas',
        image: 'https://via.placeholder.com/400x300/d4af37/ffffff?text=Torii+3D',
        technologies: ['Blender', 'After Effects'],
        link: '#'
    },
    {
        id: 6,
        title: 'API REST Escalável',
        category: 'code',
        description: 'Backend robusto para aplicações de grande escala',
        image: 'https://via.placeholder.com/400x300/4a4a4a/ffffff?text=API+REST',
        technologies: ['Node.js', 'Express', 'PostgreSQL'],
        link: '#'
    }
];

class Portfolio {
    constructor() {
        this.grid = document.querySelector('.portfolio-grid');
        this.filters = document.querySelectorAll('.filter-btn');
        this.currentFilter = 'all';
        
        this.init();
    }
    
    init() {
        this.renderProjects();
        
        this.filters.forEach(btn => {
            btn.addEventListener('click', () => {
                this.filters.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                this.currentFilter = btn.dataset.filter;
                this.renderProjects();
            });
        });
    }
    
    renderProjects() {
        const filtered = this.currentFilter === 'all' 
            ? portfolioData 
            : portfolioData.filter(p => p.category === this.currentFilter);
        
        this.grid.innerHTML = filtered.map(project => `
            <div class="project-card" data-project="${project.id}">
                <img src="${project.image}" alt="${project.title}" class="project-image">
                <div class="project-info">
                    <span class="project-category">${this.getCategoryName(project.category)}</span>
                    <h3 class="project-title">${project.title}</h3>
                    <p class="project-description">${project.description}</p>
                </div>
            </div>
        `).join('');
        
        // Adicionar event listeners
        document.querySelectorAll('.project-card').forEach(card => {
            card.addEventListener('click', () => {
                const projectId = parseInt(card.dataset.project);
                this.showProjectModal(projectId);
            });
        });
    }
    
    getCategoryName(category) {
        const names = {
            web: 'Web Design',
            art: 'Arte Digital',
            code: 'Código'
        };
        return names[category] || category;
    }
    
    showProjectModal(projectId) {
        const project = portfolioData.find(p => p.id === projectId);
        if (!project) return;
        
        const modal = document.getElementById('project-modal');
        const details = document.getElementById('project-details');
        
        details.innerHTML = `
            <img src="${project.image}" alt="${project.title}" style="width: 100%; border-radius: 10px; margin-bottom: 2rem;">
            <h2 style="color: var(--gold-subtle); margin-bottom: 1rem;">${project.title}</h2>
            <span class="project-category">${this.getCategoryName(project.category)}</span>
            <p style="margin: 1.5rem 0; line-height: 1.8;">${project.description}</p>
            <h3 style="color: var(--torii-red); margin: 1.5rem 0 1rem;">Tecnologias Utilizadas:</h3>
            <div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 2rem;">
                ${project.technologies.map(tech => `
                    <span class="tool-badge">${tech}</span>
                `).join('')}
            </div>
            <a href="${project.link}" class="cta-button" style="display: inline-block; text-decoration: none;">
                <span>Ver Projeto Completo</span>
            </a>
            ${state.isLoggedIn ? `
                <div style="margin-top: 2rem; padding: 1.5rem; background: rgba(196, 30, 58, 0.1); border-radius: 10px;">
                    <h3 style="color: var(--gold-subtle); margin-bottom: 1rem;">Comentários</h3>
                    <textarea placeholder="Deixe seu comentário..." style="width: 100%; padding: 1rem; background: rgba(0,0,0,0.3); border: 1px solid rgba(255,255,255,0.2); border-radius: 10px; color: white; font-family: var(--font-jp); min-height: 100px;"></textarea>
                    <button class="submit-btn" style="margin-top: 1rem; width: auto; padding: 0.8rem 2rem;">Enviar Comentário</button>
                </div>
            ` : ''}
        `;
        
        modal.classList.add('active');
    }
}

// ===================================
// FORMULÁRIO DE CONTATO
// ===================================

class ContactForm {
    constructor() {
        this.form = document.getElementById('contact-form');
        this.success = document.getElementById('form-success');
        this.init();
    }
    
    init() {
        this.form.addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleSubmit();
        });
    }
    
    handleSubmit() {
        const formData = {
            name: document.getElementById('name').value,
            email: document.getElementById('email').value,
            subject: document.getElementById('subject').value,
            message: document.getElementById('message').value
        };
        
        // Simulação de envio
        console.log('Formulário enviado:', formData);
        
        // Mostrar mensagem de sucesso
        this.form.style.display = 'none';
        this.success.classList.add('active');
        
        // Resetar após 5 segundos
        setTimeout(() => {
            this.form.style.display = 'block';
            this.success.classList.remove('active');
            this.form.reset();
        }, 5000);
    }
}

// ===================================
// SISTEMA DE AUTENTICAÇÃO
// ===================================

class AuthSystem {
    constructor() {
        this.modal = document.getElementById('auth-modal');
        this.loginBtn = document.getElementById('login-btn');
        this.closeBtn = this.modal.querySelector('.modal-close');
        this.tabs = document.querySelectorAll('.auth-tab');
        this.forms = document.querySelectorAll('.auth-form');
        this.switchLinks = document.querySelectorAll('.switch-auth');
        
        this.init();
    }
    
    init() {
        this.loginBtn.addEventListener('click', (e) => {
            e.preventDefault();
            this.modal.classList.add('active');
        });
        
        this.closeBtn.addEventListener('click', () => {
            this.modal.classList.remove('active');
        });
        
        this.tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                this.switchTab(tab.dataset.tab);
            });
        });
        
        this.switchLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                this.switchTab(link.dataset.switch);
            });
        });
        
        document.getElementById('login-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleLogin();
        });
        
        document.getElementById('register-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handleRegister();
        });
    }
    
    switchTab(tab) {
        this.tabs.forEach(t => t.classList.remove('active'));
        this.forms.forEach(f => f.classList.remove('active'));
        
        document.querySelector(`[data-tab="${tab}"]`).classList.add('active');
        document.getElementById(`${tab}-form`).classList.add('active');
    }
    
    handleLogin() {
        const email = document.getElementById('login-email').value;
        const password = document.getElementById('login-password').value;
        
        // Simulação de login
        state.isLoggedIn = true;
        state.currentUser = { email, name: email.split('@')[0] };
        
        this.modal.classList.remove('active');
        this.updateUI();
        
        showNotification('Login realizado com sucesso!', 'success');
    }
    
    handleRegister() {
        const name = document.getElementById('register-name').value;
        const email = document.getElementById('register-email').value;
        const password = document.getElementById('register-password').value;
        
        // Simulação de registro
        state.isLoggedIn = true;
        state.currentUser = { email, name };
        
        this.modal.classList.remove('active');
        this.updateUI();
        
        showNotification('Conta criada com sucesso!', 'success');
    }
    
    updateUI() {
        if (state.isLoggedIn) {
            this.loginBtn.textContent = `Olá, ${state.currentUser.name}`;
        } else {
            this.loginBtn.textContent = 'Login';
        }
    }
}

// ===================================
// MODAIS
// ===================================

// Fechar modais ao clicar fora
window.addEventListener('click', (e) => {
    if (e.target.classList.contains('modal')) {
        e.target.classList.remove('active');
    }
});

// ===================================
// MODOS DE TEMA
// ===================================

class ThemeManager {
    constructor() {
        this.zenBtn = document.getElementById('zen-mode');
        this.hackerBtn = document.getElementById('hacker-mode');
        this.accessibilityBtn = document.getElementById('accessibility-mode');
        this.ambientSound = document.getElementById('ambient-sound');
        
        this.init();
    }
    
    init() {
        this.zenBtn.addEventListener('click', () => this.toggleZenMode());
        this.hackerBtn.addEventListener('click', () => this.toggleHackerMode());
        this.accessibilityBtn.addEventListener('click', () => this.toggleAccessibilityMode());
    }
    
    toggleZenMode() {
        document.body.classList.toggle('zen-mode');
        document.body.classList.remove('hacker-mode');
        
        if (document.body.classList.contains('zen-mode')) {
            this.ambientSound.play();
            showNotification('Modo Zen ativado 🌸', 'info');
        } else {
            this.ambientSound.pause();
        }
    }
    
    toggleHackerMode() {
        document.body.classList.toggle('hacker-mode');
        document.body.classList.remove('zen-mode');
        
        if (document.body.classList.contains('hacker-mode')) {
            showNotification('Modo Hacker ativado ⚡', 'info');
            this.createMatrixEffect();
        }
    }
    
    toggleAccessibilityMode() {
        document.body.classList.toggle('accessibility-mode');
        showNotification('Modo Acessibilidade ' + (document.body.classList.contains('accessibility-mode') ? 'ativado' : 'desativado'), 'info');
    }
    
    createMatrixEffect() {
        // Efeito Matrix simplificado
        const canvas = document.getElementById('particles');
        const ctx = canvas.getContext('2d');
        
        if (document.body.classList.contains('hacker-mode')) {
            const chars = 'ハーロ01';
            const fontSize = 14;
            const columns = canvas.width / fontSize;
            const drops = Array(Math.floor(columns)).fill(1);
            
            const draw = () => {
                ctx.fillStyle = 'rgba(13, 2, 8, 0.05)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                
                ctx.fillStyle = '#00ff41';
                ctx.font = fontSize + 'px monospace';
                
                for (let i = 0; i < drops.length; i++) {
                    const text = chars[Math.floor(Math.random() * chars.length)];
                    ctx.fillText(text, i * fontSize, drops[i] * fontSize);
                    
                    if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                        drops[i] = 0;
                    }
                    drops[i]++;
                }
            };
            
            const interval = setInterval(() => {
                if (!document.body.classList.contains('hacker-mode')) {
                    clearInterval(interval);
                }
                draw();
            }, 33);
        }
    }
}

// ===================================
// SISTEMA DE CONQUISTAS
// ===================================

function unlockAchievement(achievementId) {
    if (state.achievements[achievementId]) return;
    
    state.achievements[achievementId] = true;
    
    const achievement = document.querySelector(`[data-achievement="${achievementId}"]`);
    if (achievement) {
        achievement.classList.remove('locked');
        achievement.classList.add('unlocked');
    }
    
    const names = {
        explorer: 'Explorador Desbloqueado!',
        reader: 'Leitor Atento Desbloqueado!',
        konami: 'Samurai Secreto Desbloqueado!'
    };
    
    showNotification(names[achievementId] || 'Conquista Desbloqueada!', 'success');
}

// ===================================
// KONAMI CODE (Easter Egg)
// ===================================

document.addEventListener('keydown', (e) => {
    state.konamiCode.push(e.key);
    
    // Manter apenas os últimos 10 inputs
    if (state.konamiCode.length > 10) {
        state.konamiCode.shift();
    }
    
    // Verificar se a sequência está correta
    const isCorrect = state.konamiSequence.every((key, index) => {
        return key === state.konamiCode[index];
    });
    
    if (isCorrect && !state.achievements.konami) {
        activateSamuraiMode();
        unlockAchievement('konami');
    }
});

function activateSamuraiMode() {
    document.body.style.filter = 'hue-rotate(45deg)';
    showNotification('🥋 MODO SAMURAI ATIVADO! 🥋', 'success');
    
    // Resetar após 10 segundos
    setTimeout(() => {
        document.body.style.filter = '';
    }, 10000);
}

// ===================================
// SISTEMA DE NOTIFICAÇÕES
// ===================================

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        padding: 1.5rem 2rem;
        background: ${type === 'success' ? 'var(--torii-red)' : 'var(--gold-subtle)'};
        color: white;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        z-index: 10001;
        animation: slideInRight 0.3s ease;
        font-weight: 600;
        max-width: 300px;
    `;
    notification.textContent = message;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Adicionar animações
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from { transform: translateX(400px); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOutRight {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(400px); opacity: 0; }
    }
`;
document.head.appendChild(style);

// ===================================
// INICIALIZAÇÃO
// ===================================

document.addEventListener('DOMContentLoaded', () => {
    // Inicializar todos os sistemas
    new ParticleSystem();
    new Navigation();
    new ParallaxHero();
    new StatsAnimator();
    new SkillsAnimator();
    new Portfolio();
    new ContactForm();
    new AuthSystem();
    new ThemeManager();
    
    console.log('%c🌸 Bem-vindo ao portfólio de Hiro! 🌸', 'color: #c41e3a; font-size: 20px; font-weight: bold;');
    console.log('%cDica: Tente o código Konami! ⬆️⬆️⬇️⬇️⬅️➡️⬅️➡️BA', 'color: #d4af37; font-size: 14px;');
});
