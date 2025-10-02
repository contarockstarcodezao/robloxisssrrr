# 🌸 Portfólio Hiro - Designer & Programador

## 📋 Sobre o Projeto

Site portfólio moderno e interativo para Hiro, um designer e programador brasileiro de origem japonesa. O site combina estética japonesa com tecnologia web moderna, criando uma experiência única e imersiva.

---

## ✨ Características Principais

### 🎨 Design Visual
- **Paleta Oriental**: Vermelho torii (#c41e3a), preto profundo, branco suave, dourado sutil
- **Elementos Japoneses**: Montanhas, brumas, cerejeiras, templos em silhueta
- **Tipografia Elegante**: Noto Sans JP + Cinzel
- **Efeitos Visuais**: Partículas flutuantes, transições suaves, parallax, hover com pinceladas

### 🧩 Estrutura Completa

#### 1. **Seção Início (Hero)**
- Saudação personalizada
- Fundo animado com paisagem oriental ao entardecer
- Montanhas em camadas com efeito parallax
- Botão "Explorar Portfólio" com efeito de pincel
- Indicador de scroll animado

#### 2. **Sobre Mim**
- Foto estilizada com moldura torii decorativa
- Biografia completa da jornada profissional
- Estatísticas animadas (projetos, experiência, clientes)
- Habilidades divididas em categorias:
  - **Design**: UI/UX, Ilustração, Motion Design, Branding
  - **Programação**: Web, JavaScript/TypeScript, Python/Game Dev, Automação
  - **Ferramentas**: Figma, Adobe Suite, VS Code, React, Node.js
- Barras de progresso animadas ao scroll

#### 3. **Portfólio**
- Galeria com 6 projetos de exemplo
- Filtros por categoria: Todos, Web Design, Arte Digital, Código
- Cards interativos com hover effect
- Modal detalhado para cada projeto com:
  - Imagem ampliada
  - Descrição completa
  - Tecnologias utilizadas
  - Link para projeto
  - Sistema de comentários (para usuários logados)

#### 4. **Sistema de Login/Registro**
- Modal com transição suave
- Alternância entre Login e Registro
- Campos animados com labels flutuantes
- Usuários registrados podem:
  - Comentar nos projetos
  - Salvar favoritos
  - Desbloquear conteúdo exclusivo

#### 5. **Contato**
- Formulário personalizado com animações
- Campos: Nome, E-mail, Assunto, Mensagem
- Validação em tempo real
- Mensagem de sucesso animada
- Links para redes sociais (GitHub, LinkedIn, Instagram, Behance)
- QR Code para download de currículo
- Sistema de conquistas

### 🎮 Funcionalidades Interativas

#### 🌸 **Modo Zen**
- Fundo claro e suave
- Sons de natureza (ambiente relaxante)
- Layout minimalista
- Cores pastéis

#### ⚡ **Modo Hacker**
- Fundo escuro (#0d0208)
- Terminal animado com efeito Matrix
- Fonte monoespaçada
- Cores verde e azul neon
- Efeitos de código em cascata

#### ♿ **Modo Acessibilidade**
- Fonte ampliada (18px)
- Contraste aumentado
- Espaçamento maior entre letras
- Maior altura de linha

#### 🏆 **Sistema de Conquistas**
Três conquistas desbloqueáveis:

1. **Explorador 🗺️**: Visite todas as 4 seções
2. **Leitor Atento 📖**: Leia a seção "Sobre Mim" até as estatísticas
3. **Samurai 🥋**: Digite o código Konami

#### 🥋 **Easter Egg - Código Konami**
Digite a sequência: `↑ ↑ ↓ ↓ ← → ← → B A`
- Ativa o "Modo Samurai" por 10 segundos
- Aplica filtro de cor especial
- Desbloqueia conquista secreta

### 💫 Efeitos e Animações

- **Partículas Flutuantes**: Canvas com 50 partículas vermelhas
- **Parallax Hero**: Montanhas se movem com o mouse
- **Scroll Spy**: Navegação rastreia seção ativa
- **Fade In Up**: Animações de entrada suaves
- **Hover Effects**: Transformações e sombras em cards
- **Progress Bars**: Barras de habilidade animadas ao scroll
- **Modal Slide In**: Modais com entrada suave
- **Number Counter**: Estatísticas com contagem animada

---

## 🚀 Instalação e Uso

### Requisitos
- Navegador web moderno (Chrome, Firefox, Safari, Edge)
- Servidor local (opcional, pode abrir direto no navegador)

### Instalação

1. **Clone ou baixe os arquivos**
```bash
cd "SITE HIRO"
```

2. **Abra o arquivo index.html**
- Duplo clique em `index.html`, ou
- Use um servidor local:
```bash
# Python
python -m http.server 8000

# Node.js (http-server)
npx http-server

# VS Code Live Server
Clique direito > Open with Live Server
```

3. **Acesse no navegador**
```
http://localhost:8000
```

---

## 📂 Estrutura de Arquivos

```
SITE HIRO/
├── index.html          # Estrutura HTML principal
├── styles.css          # Estilos CSS completos
├── script.js           # JavaScript interativo
├── README.md           # Este arquivo
└── assets/             # (opcional) Imagens e recursos
    ├── hiro-photo.jpg
    └── zen-ambient.mp3
```

---

## 🎨 Paleta de Cores

```css
--torii-red: #c41e3a      /* Vermelho torii */
--deep-black: #0a0a0a     /* Preto profundo */
--soft-white: #f5f5f5     /* Branco suave */
--gold-subtle: #d4af37    /* Dourado sutil */
--charcoal: #1a1a1a       /* Carvão */
--sakura-pink: #ffb7c5    /* Rosa cerejeira */
```

---

## 🔧 Personalização

### Alterar Informações Pessoais

1. **Nome e Título**: Edite no `index.html`:
```html
<span class="hero-name">Hiro</span>
<p class="hero-description">Designer & Programador...</p>
```

2. **Biografia**: Seção "Sobre Mim" em `index.html`

3. **Estatísticas**: Altere os valores em:
```html
<span class="stat-number" data-target="150">0</span>
```

4. **Habilidades**: Edite as barras de progresso:
```html
<div class="skill-progress" data-progress="95"></div>
```

### Adicionar Projetos ao Portfólio

Edite o array `portfolioData` em `script.js`:

```javascript
{
    id: 7,
    title: 'Seu Projeto',
    category: 'web', // 'web', 'art', ou 'code'
    description: 'Descrição do projeto',
    image: 'url-da-imagem.jpg',
    technologies: ['React', 'Node.js'],
    link: 'https://seu-link.com'
}
```

### Alterar Redes Sociais

No `index.html`, seção de contato:
```html
<a href="https://github.com/seu-usuario" class="social-link">
```

---

## 📱 Responsividade

O site é totalmente responsivo com breakpoints em:
- **Desktop**: > 1024px
- **Tablet**: 768px - 1024px
- **Mobile**: < 768px

### Recursos Mobile
- Menu hamburguer
- Layout adaptativo
- Imagens otimizadas
- Touch events

---

## ⚙️ Tecnologias Utilizadas

- **HTML5**: Estrutura semântica
- **CSS3**: Animações, Grid, Flexbox
- **JavaScript ES6+**: Classes, Promises, Async/Await
- **Canvas API**: Sistema de partículas
- **Intersection Observer**: Animações ao scroll
- **LocalStorage**: Salvamento de preferências (futuro)

---

## 🎯 Recursos Avançados

### Sistema de Partículas
- Canvas 2D
- 50 partículas animadas
- Movimento aleatório com wraparound

### Parallax Hero
- 3 camadas de montanhas
- Movimento baseado na posição do mouse
- Suavização de movimento

### Scroll Spy
- Rastreamento de seções visitadas
- Navegação ativa automática
- Sistema de conquistas

---

## 🐛 Troubleshooting

### Partículas não aparecem
- Verifique se o JavaScript está habilitado
- Console do navegador (F12) para ver erros

### Sons não tocam
- Navegadores bloqueiam autoplay
- Clique no botão Zen Mode para ativar manualmente

### Animações lentas
- Desative o modo acessibilidade se estiver ativo
- Feche outras abas do navegador

---

## 📈 Melhorias Futuras

- [ ] Backend para formulário de contato (Node.js/PHP)
- [ ] Integração com CMS (Strapi/WordPress)
- [ ] Blog integrado
- [ ] Dark mode persistente (LocalStorage)
- [ ] Galeria de fotos expandida
- [ ] Sistema de busca
- [ ] Internacionalização (EN/JP)
- [ ] PWA (Progressive Web App)
- [ ] Analytics (Google Analytics)
- [ ] SEO otimizado

---

## 🔒 Segurança

**Nota**: Este é um projeto front-end demonstrativo. Para produção:
- Implemente autenticação real (JWT, OAuth)
- Valide dados no servidor
- Use HTTPS
- Sanitize inputs (XSS protection)
- Rate limiting
- CSRF protection

---

## 📄 Licença

Este projeto é de código aberto para fins educacionais e de portfólio.

---

## 👤 Autor

**Hiro**
- Portfolio: [Link do site]
- GitHub: [@hiro](https://github.com/hiro)
- LinkedIn: [Hiro](https://linkedin.com/in/hiro)
- Email: contato@hiro.dev

---

## 🙏 Agradecimentos

- Inspiração: Cultura japonesa, minimalismo oriental
- Fontes: Google Fonts (Noto Sans JP, Cinzel)
- Icons: SVG inline
- Placeholders: via.placeholder.com

---

## 📞 Suporte

Encontrou um bug ou tem uma sugestão?
- Abra uma issue no GitHub
- Envie um e-mail
- Entre em contato via redes sociais

---

**Feito com ❤️ e ☕ por Hiro**

*"Arte e código unidos pela paixão"*

🌸 廣 🌸
