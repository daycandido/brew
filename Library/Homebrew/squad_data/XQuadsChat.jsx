import { useState, useRef, useEffect } from "react";

const SQUADS_DATA = {
  "advisory-board": {
    "meta": { "emoji": "\u{1F3DB}️", "label": "Advisory Board", "desc": "Conselho estratégico" },
    "agents": {
      "board-chair": "Board Chair - Advisory Board Orchestrator",
      "brene-brown": "Brene Brown - Vulnerability, Courage & Empathic Leadership",
      "charlie-munger": "Charlie Munger - Mental Models & Rational Decision-Making",
      "derek-sivers": "Derek Sivers - Simplicity & Contrarian Entrepreneurship",
      "naval-ravikant": "Naval Ravikant - Wealth, Leverage & Happiness",
      "patrick-lencioni": "Patrick Lencioni - Organizational Health & Team Dynamics",
      "peter-thiel": "Peter Thiel - Monopoly, Secrets & Zero-to-One Thinking",
      "ray-dalio": "Ray Dalio - Systematic Decision-Making & Radical Truth",
      "reid-hoffman": "Reid Hoffman - Venture Philosophy & Blitzscaling",
      "simon-sinek": "Simon Sinek - Purpose-Driven Leadership & Infinite Mindset",
      "yvon-chouinard": "Yvon Chouinard - Purpose, Planet & Anti-Growth"
    }
  },
  "hormozi-squad": {
    "meta": { "emoji": "\u{1F4B0}", "label": "Hormozi Squad", "desc": "Frameworks Hormozi" },
    "agents": {
      "hormozi-chief": "Hormozi Chief - Squad Orchestrator",
      "hormozi-offers": "Hormozi Offers - Grand Slam Offer Architect",
      "hormozi-leads": "Hormozi Leads - $100M Leads & Core 4",
      "hormozi-pricing": "Hormozi Pricing - Value-Based Pricing",
      "hormozi-closer": "Hormozi Closer - CLOSER Framework",
      "hormozi-content": "Hormozi Content - Content Machine",
      "hormozi-hooks": "Hormozi Hooks - Attention Capture",
      "hormozi-ads": "Hormozi Ads - Paid Advertising Strategy",
      "hormozi-launch": "Hormozi Launch - Market Entry",
      "hormozi-retention": "Hormozi Retention - Churn Reduction & LTV",
      "hormozi-scale": "Hormozi Scale - Business Scaling & Systems",
      "hormozi-models": "Hormozi Models - Business Model Design",
      "hormozi-audit": "Hormozi Audit - Business Evaluation",
      "hormozi-copy": "Hormozi Copy - Hormozi-Style Copywriting",
      "hormozi-advisor": "Hormozi Advisor - Strategic Business Advisor",
      "hormozi-workshop": "Hormozi Workshop - Workshop Design"
    }
  },
  "copy-squad": {
    "meta": { "emoji": "✍️", "label": "Copy Squad", "desc": "Copywriting experts" },
    "agents": {
      "copy-chief": "Cyrus - Copy Chief Squad Orchestrator",
      "gary-halbert": "Gary Halbert - Raw Emotional Storytelling",
      "eugene-schwartz": "Eugene Schwartz - Market Awareness & Strategic Copy",
      "gary-bencivenga": "Gary Bencivenga - Master of Proof",
      "claude-hopkins": "Claude Hopkins - Scientific Advertising",
      "john-carlton": "John Carlton - The Sales Detective",
      "clayton-makepeace": "Clayton Makepeace - Emotional Selling",
      "robert-collier": "Robert Collier - Empathy & Mental Movie",
      "david-ogilvy": "David Ogilvy - Father of Modern Advertising",
      "joe-sugarman": "Joe Sugarman - Slippery Slide Master",
      "dan-kennedy": "Dan Kennedy - No B.S. Direct Response",
      "frank-kern": "Frank Kern - Intent-Based Branding",
      "russell-brunson": "Russell Brunson - Funnel Architect",
      "stefan-georgi": "Stefan Georgi - RMBC Method",
      "jon-benson": "Jon Benson - VSL Inventor",
      "ben-settle": "Ben Settle - Daily Email Maverick",
      "ry-schwartz": "Ry Schwartz - Conversion Coach",
      "todd-brown": "Todd Brown - Big Marketing Ideas",
      "andre-chaperon": "Andre Chaperon - Email Storytelling",
      "dan-koe": "Dan Koe - One-Person Business",
      "david-deutsch": "David Deutsch - CopyTHINKING Expert",
      "jim-rutz": "Jim Rutz - Magalog Pioneer",
      "parris-lampropoulos": "Parris Lampropoulos - Fascinations Master"
    }
  },
  "brand-squad": {
    "meta": { "emoji": "\u{1F3AF}", "label": "Brand Squad", "desc": "Branding e identidade" },
    "agents": {
      "brand-chief": "Brand Chief - Squad Orchestrator",
      "al-ries": "Al Ries - Father of Positioning",
      "david-aaker": "David Aaker - Father of Modern Branding",
      "jean-noel-kapferer": "Jean-Noel Kapferer - Brand Identity Prism",
      "kevin-keller": "Kevin Keller - CBBE Pyramid Creator",
      "byron-sharp": "Byron Sharp - Evidence-Based Brand Growth",
      "marty-neumeier": "Marty Neumeier - Radical Differentiation",
      "donald-miller": "Donald Miller - StoryBrand SB7 Framework",
      "emily-heyward": "Emily Heyward - Startup Brand Architect",
      "denise-yohn": "Denise Lee Yohn - Brand-Culture Fusion",
      "alina-wheeler": "Alina Wheeler - Brand Identity Authority",
      "naming-strategist": "Naming Strategist - Brand Naming",
      "archetype-consultant": "Archetype Consultant - Brand Personality",
      "domain-scout": "Domain Scout - Digital Naming Viability",
      "miller-sticky-brand": "Miller Sticky Brand - StoryBrand Implementation"
    }
  },
  "c-level-squad": {
    "meta": { "emoji": "\u{1F454}", "label": "C-Level Squad", "desc": "CMO, CTO, COO, CAIO" },
    "agents": {
      "vision-chief": "Vision Chief - CEO Strategic Orchestrator",
      "cmo-architect": "CMO Architect - Marketing Strategy",
      "cto-architect": "CTO Architect - Technology Strategy",
      "coo-orchestrator": "COO Orchestrator - Operational Excellence",
      "cio-engineer": "CIO Engineer - Digital Infrastructure",
      "caio-architect": "CAIO Architect - AI Strategy"
    }
  },
  "storytelling": {
    "meta": { "emoji": "\u{1F4D6}", "label": "Storytelling", "desc": "Narrativa e pitch" },
    "agents": {
      "story-chief": "Story Chief - Storytelling Orchestrator",
      "joseph-campbell": "Joseph Campbell - Hero's Journey",
      "blake-snyder": "Blake Snyder - Save the Cat Beat Sheet",
      "dan-harmon": "Dan Harmon - Story Circle",
      "shawn-coyne": "Shawn Coyne - Story Grid",
      "nancy-duarte": "Nancy Duarte - Presentation Storytelling",
      "park-howell": "Park Howell - ABT & Story Cycle",
      "kindra-hall": "Kindra Hall - Business Storytelling",
      "matthew-dicks": "Matthew Dicks - Personal Storytelling",
      "oren-klaff": "Oren Klaff - Pitch Anything",
      "keith-johnstone": "Keith Johnstone - Impro & Spontaneity",
      "marshall-ganz": "Marshall Ganz - Public Narrative"
    }
  },
  "traffic-masters": {
    "meta": { "emoji": "\u{1F4E1}", "label": "Traffic Masters", "desc": "Trafego pago" },
    "agents": {
      "traffic-chief": "Traffic Chief - Traffic Orchestrator",
      "molly-pittman": "Molly Pittman - Facebook Ads Strategist",
      "depesh-mandalia": "Depesh Mandalia - BPM Method",
      "kasim-aslam": "Kasim Aslam - Google Ads Authority",
      "tom-breeze": "Tom Breeze - YouTube Ads Authority",
      "nicholas-kusmich": "Nicholas Kusmich - Contextual Congruence",
      "pedro-sobral": "Pedro Sobral - Gestor de Trafego Pioneer",
      "ralph-burns": "Ralph Burns - Performance Marketing",
      "ad-midas": "Ad Midas - Ad Creative Strategy",
      "ads-analyst": "Ads Analyst - Account Audit",
      "creative-analyst": "Creative Analyst - Creative Performance",
      "media-buyer": "Media Buyer - Cross-Platform Execution",
      "performance-analyst": "Performance Analyst - Campaign Data",
      "pixel-specialist": "Pixel Specialist - Tracking & Attribution",
      "fiscal": "Fiscal - Ad Budget & Finance",
      "scale-optimizer": "Scale Optimizer - Campaign Scaling"
    }
  },
  "data-squad": {
    "meta": { "emoji": "\u{1F4CA}", "label": "Data Squad", "desc": "Analytics e growth" },
    "agents": {
      "data-chief": "Datum - Data Chief Orchestrator",
      "avinash-kaushik": "Avinash Kaushik - Web Analytics",
      "peter-fader": "Peter Fader - Customer Lifetime Value",
      "sean-ellis": "Sean Ellis - Growth Hacking & PMF",
      "wes-kao": "Wes Kao - Cohort Education & Audience",
      "nick-mehta": "Nick Mehta - Customer Success",
      "david-spinks": "David Spinks - Community Strategy"
    }
  },
  "design-squad": {
    "meta": { "emoji": "\u{1F3A8}", "label": "Design Squad", "desc": "UX e design systems" },
    "agents": {
      "design-chief": "Design Chief - Design Orchestrator",
      "brad-frost": "Brad Frost - Atomic Design",
      "dan-mall": "Dan Mall - Design Systems at Scale",
      "dave-malouf": "Dave Malouf - DesignOps Pioneer",
      "design-system-architect": "Design System Architect - Tokens & Components",
      "ui-engineer": "UI Engineer - Frontend Implementation",
      "ux-designer": "UX Designer - User Research",
      "visual-generator": "Visual Generator - Visual Assets"
    }
  },
  "movement": {
    "meta": { "emoji": "\u{1F525}", "label": "Movement", "desc": "Construcao de movimentos" },
    "agents": {
      "movement-chief": "Movement Chief - Movement Orchestrator",
      "fenomenologo": "Fenomenologo - Phenomenological Analysis",
      "identitario": "Identitario - Identity Architecture",
      "movement-architect": "Movement Architect - Community Design",
      "manifestador": "Manifestador - Manifesto Creation",
      "estrategista-de-ciclo": "Estrategista de Ciclo - Growth Cycles",
      "analista-de-impacto": "Analista de Impacto - Impact Measurement"
    }
  },
  "cybersecurity": {
    "meta": { "emoji": "\u{1F510}", "label": "Cybersecurity", "desc": "Seguranca e pentest" },
    "agents": {
      "cyber-chief": "Cyber Chief - Security Orchestrator",
      "peter-kim": "Peter Kim - Red Team Operations",
      "georgia-weidman": "Georgia Weidman - Mobile Security",
      "jim-manico": "Jim Manico - Application Security",
      "chris-sanders": "Chris Sanders - Network Security",
      "omar-santos": "Omar Santos - Vulnerability Management",
      "marcus-carey": "Marcus Carey - Security Leadership",
      "cartographer": "Cartographer - Attack Surface Mapping",
      "busterer": "Busterer - Web Content Discovery",
      "dirber": "Dirber - Service Enumeration",
      "fuzzer": "Fuzzer - Input Fuzzing",
      "rogue": "Rogue - Exploitation Specialist",
      "ripper": "Ripper - Credential Cracking",
      "command-generator": "Command Generator - Tool Commands",
      "shannon-runner": "Shannon Runner - OSINT Collection"
    }
  },
  "claude-code-mastery": {
    "meta": { "emoji": "⚡", "label": "Claude Code", "desc": "Claude Code & MCP" },
    "agents": {
      "claude-mastery-chief": "Orion - Claude Code Orchestrator",
      "config-engineer": "Sigil - Configuration & Permissions",
      "hooks-architect": "Latch - Lifecycle Hooks & Automation",
      "mcp-integrator": "Piper - MCP Server Integration",
      "project-integrator": "Atlas - Project Integration & CI/CD",
      "roadmap-sentinel": "Beacon - Roadmap & Feature Tracking",
      "skill-craftsman": "Rune - Skills & Plugins Creation",
      "swarm-orchestrator": "Nexus - Multi-Agent Orchestration"
    }
  }
};

const squadOrder = [
  "advisory-board", "hormozi-squad", "copy-squad", "brand-squad",
  "c-level-squad", "storytelling", "traffic-masters", "data-squad",
  "design-squad", "movement", "cybersecurity", "claude-code-mastery"
];

const AGENT_NAMES = {
  "board-chair": "Orquestra o Conselho",
  "brene-brown": "Lidera com Vulnerabilidade",
  "charlie-munger": "Aplica Modelos Mentais",
  "derek-sivers": "Simplifica Decisoes",
  "naval-ravikant": "Estrategia de Riqueza",
  "patrick-lencioni": "Resolve Disfuncoes de Time",
  "peter-thiel": "Pensa de Forma Contraria",
  "ray-dalio": "Cria Sistemas de Decisao",
  "reid-hoffman": "Escala com Redes",
  "simon-sinek": "Define o Proposito",
  "yvon-chouinard": "Negocio com Proposito",
  "al-ries": "Posiciona a Marca",
  "alina-wheeler": "Cria Identidade Visual",
  "archetype-consultant": "Define Arquetipo da Marca",
  "brand-chief": "Orquestra o Branding",
  "byron-sharp": "Cresce com Evidencia",
  "david-aaker": "Constroi Brand Equity",
  "denise-yohn": "Alinha Marca e Cultura",
  "domain-scout": "Avalia Dominios Digitais",
  "donald-miller": "Clarifica a Mensagem",
  "emily-heyward": "Lanca Marcas do Zero",
  "jean-noel-kapferer": "Define Identidade da Marca",
  "kevin-keller": "Mede Brand Equity",
  "marty-neumeier": "Diferencia Radicalmente",
  "miller-sticky-brand": "Implementa StoryBrand",
  "naming-strategist": "Cria Nomes de Marca",
  "caio-architect": "Estrategia de IA",
  "cio-engineer": "Infraestrutura Digital",
  "cmo-architect": "Arquitetura de Marketing",
  "coo-orchestrator": "Excelencia Operacional",
  "cto-architect": "Estrategia de Tecnologia",
  "vision-chief": "Visao e Lideranca CEO",
  "claude-mastery-chief": "Orquestra Claude Code",
  "config-engineer": "Configura Settings",
  "hooks-architect": "Cria Automacoes com Hooks",
  "mcp-integrator": "Integra Servidores MCP",
  "project-integrator": "Integra Projetos e CI/CD",
  "roadmap-sentinel": "Monitora Roadmap Claude",
  "skill-craftsman": "Cria Skills e Plugins",
  "swarm-orchestrator": "Orquestra Multi-Agentes",
  "andre-chaperon": "Escreve Sequencias de Email",
  "ben-settle": "Email com Personalidade",
  "claude-hopkins": "Copy Cientifico e Testavel",
  "clayton-makepeace": "Copy Emocional com Prova",
  "copy-chief": "Orquestra o Copywriting",
  "dan-kennedy": "Copy Direto Sem Frescura",
  "dan-koe": "Conteudo de Marca Pessoal",
  "david-deutsch": "Cria Big Ideas de Copy",
  "david-ogilvy": "Copy de Marca e Pesquisa",
  "eugene-schwartz": "Diagnostica Consciencia de Mercado",
  "frank-kern": "Marketing de Valor Primeiro",
  "gary-bencivenga": "Copy com Prova Maxima",
  "gary-halbert": "Copy Emocional e Visceral",
  "jim-rutz": "Copy Anti-Tedio",
  "joe-sugarman": "Copy que Nao Para de Fluir",
  "john-carlton": "Descobre o Angulo de Venda",
  "jon-benson": "Escreve VSL",
  "parris-lampropoulos": "Copy de Alto Controle",
  "robert-collier": "Copy com Empatia Profunda",
  "russell-brunson": "Arquiteta Funnels de Venda",
  "ry-schwartz": "Transforma Crencas em Vendas",
  "stefan-georgi": "Metodo RMBC de Copy",
  "todd-brown": "Cria Big Marketing Idea",
  "busterer": "Descobre Conteudo Web Oculto",
  "cartographer": "Mapeia Superficie de Ataque",
  "chris-sanders": "Monitora Seguranca de Rede",
  "command-generator": "Gera Comandos de Ferramentas",
  "cyber-chief": "Orquestra Operacoes de Seguranca",
  "dirber": "Enumera Servicos de Rede",
  "fuzzer": "Testa Inputs e Parametros",
  "georgia-weidman": "Pentest Mobile e Exploits",
  "jim-manico": "Seguranca de Aplicacoes Web",
  "marcus-carey": "Lidera Times de Seguranca",
  "omar-santos": "Gerencia Vulnerabilidades",
  "peter-kim": "Metodologia de Red Team",
  "ripper": "Quebra Senhas e Hashes",
  "rogue": "Explora Vulnerabilidades",
  "shannon-runner": "Coleta Inteligencia OSINT",
  "avinash-kaushik": "Analitica Digital Acionavel",
  "data-chief": "Orquestra Analytics e Growth",
  "david-spinks": "Estrategia de Comunidade",
  "nick-mehta": "Customer Success e Retencao",
  "peter-fader": "Calcula Lifetime Value",
  "sean-ellis": "Testa Product-Market Fit",
  "wes-kao": "Design de Cursos e Audiencia",
  "brad-frost": "Atomic Design e Componentes",
  "dan-mall": "Design System em Escala",
  "dave-malouf": "Operacoes de Design",
  "design-chief": "Orquestra o Design",
  "design-system-architect": "Arquiteta Tokens e Componentes",
  "ui-engineer": "Implementa UI em Codigo",
  "ux-designer": "Pesquisa e Design de UX",
  "visual-generator": "Cria Assets Visuais",
  "hormozi-ads": "Estrategia de Trafego Pago",
  "hormozi-advisor": "Conselho Estrategico de Negocio",
  "hormozi-audit": "Audita o Negocio",
  "hormozi-chief": "Orquestra o Squad Hormozi",
  "hormozi-closer": "Fecha Vendas com CLOSER",
  "hormozi-content": "Cria Maquina de Conteudo",
  "hormozi-copy": "Escreve em Estilo Hormozi",
  "hormozi-hooks": "Cria Hooks de Atencao",
  "hormozi-launch": "Lanca Produtos e Mercados",
  "hormozi-leads": "Gera Leads com Core 4",
  "hormozi-models": "Desenha Modelo de Negocio",
  "hormozi-offers": "Cria Grand Slam Offers",
  "hormozi-pricing": "Define Preco por Valor",
  "hormozi-retention": "Reduz Churn e Aumenta LTV",
  "hormozi-scale": "Escala de $1M para $100M",
  "hormozi-workshop": "Desenha Workshops de Alto Valor",
  "analista-de-impacto": "Mede Impacto do Movimento",
  "estrategista-de-ciclo": "Estrategia de Crescimento",
  "fenomenologo": "Analisa Tensoes e Experiencias",
  "identitario": "Arquiteta Identidade Tribal",
  "manifestador": "Escreve Manifestos",
  "movement-architect": "Desenha Estrutura do Movimento",
  "movement-chief": "Orquestra Construcao de Movimento",
  "blake-snyder": "Estrutura com Save the Cat",
  "dan-harmon": "Aplica o Story Circle",
  "joseph-campbell": "Jornada do Heroi",
  "keith-johnstone": "Desbloqueio Criativo",
  "kindra-hall": "Historias que Geram Negocio",
  "marshall-ganz": "Narrativa para Movimentos",
  "matthew-dicks": "Encontra Historias Pessoais",
  "nancy-duarte": "Apresentacoes que Movem",
  "oren-klaff": "Pitch para Investidores",
  "park-howell": "ABT e Narrativa de Marca",
  "shawn-coyne": "Diagnostica e Edita Historias",
  "story-chief": "Orquestra o Storytelling",
  "ad-midas": "Cria Criativos de Anuncios",
  "ads-analyst": "Audita Contas de Anuncios",
  "creative-analyst": "Analisa Performance Criativa",
  "depesh-mandalia": "Metodo BPM no Facebook",
  "fiscal": "Gestao Financeira de Ads",
  "kasim-aslam": "Google Ads Estrategico",
  "media-buyer": "Compra Midia Multi-Plataforma",
  "molly-pittman": "Sistema de Facebook Ads",
  "nicholas-kusmich": "Facebook Ads com Contexto",
  "pedro-sobral": "Gestao de Trafego LATAM",
  "performance-analyst": "Analisa Dados de Campanhas",
  "pixel-specialist": "Tracking e Atribuicao",
  "ralph-burns": "Performance Marketing Full-Funnel",
  "scale-optimizer": "Escala Campanhas com Eficiencia",
  "tom-breeze": "YouTube Ads e Video",
  "traffic-chief": "Orquestra Trafego Pago"
};

function getAgentDisplayName(key) {
  return AGENT_NAMES[key] || key.split("-").map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(" ");
}

function isChief(agentKey) {
  return agentKey.includes("chief") || agentKey === "board-chair" || agentKey === "vision-chief";
}

export default function XQuadsChat() {
  const [activeSquad, setActiveSquad] = useState("hormozi-squad");
  const [activeAgent, setActiveAgent] = useState("hormozi-chief");
  const [openSquads, setOpenSquads] = useState(new Set(["hormozi-squad"]));
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const messagesEndRef = useRef(null);
  const inputRef = useRef(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const currentSquad = SQUADS_DATA[activeSquad];
  const currentAgentDesc = currentSquad?.agents?.[activeAgent] || "";
  const agentLabel = getAgentDisplayName(activeAgent);
  const squadLabel = currentSquad?.meta?.label || activeSquad;
  const squadEmoji = currentSquad?.meta?.emoji || "";

  function toggleSquad(squadKey) {
    setOpenSquads(prev => {
      const next = new Set(prev);
      if (next.has(squadKey)) next.delete(squadKey);
      else next.add(squadKey);
      return next;
    });
  }

  function selectAgent(squadKey, agentKey) {
    setActiveSquad(squadKey);
    setActiveAgent(agentKey);
    if (!openSquads.has(squadKey)) {
      setOpenSquads(prev => new Set([...prev, squadKey]));
    }
    setMessages([]);
    setTimeout(() => inputRef.current?.focus(), 100);
  }

  async function sendMessage() {
    if (!input.trim() || loading) return;
    const userMsg = input.trim();
    setInput("");
    const newMessages = [...messages, { role: "user", content: userMsg }];
    setMessages(newMessages);
    setLoading(true);
    try {
      const res = await fetch("/api/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          model: "claude-sonnet-4-20250514",
          max_tokens: 1000,
          system: currentAgentDesc || "You are " + agentLabel + ", a specialist agent from the " + squadLabel + " squad.",
          messages: newMessages
        })
      });
      const data = await res.json();
      const reply = data.content?.find(b => b.type === "text")?.text || "Sem resposta.";
      setMessages(prev => [...prev, { role: "assistant", content: reply }]);
    } catch (e) {
      setMessages(prev => [...prev, { role: "assistant", content: "Erro ao conectar a API." }]);
    }
    setLoading(false);
  }

  function handleKey(e) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  }

  return (
    <div style={{
      display: "flex", height: "100vh", fontFamily: "var(--font-sans)",
      background: "var(--color-background-tertiary)", overflow: "hidden"
    }}>
      {sidebarOpen && (
        <div style={{
          width: 240, flexShrink: 0, background: "var(--color-background-primary)",
          borderRight: "0.5px solid var(--color-border-tertiary)",
          display: "flex", flexDirection: "column", overflow: "hidden"
        }}>
          <div style={{
            padding: "14px 16px 10px", borderBottom: "0.5px solid var(--color-border-tertiary)",
            display: "flex", alignItems: "center", gap: 8
          }}>
            <span style={{ fontSize: 16 }}>{"⚡"}</span>
            <span style={{ fontWeight: 500, fontSize: 14, color: "var(--color-text-primary)" }}>AxialMind</span>
            <span style={{ fontSize: 11, color: "var(--color-text-tertiary)", marginLeft: "auto" }}>144 agentes</span>
          </div>
          <div style={{ flex: 1, overflowY: "auto", padding: "8px 0" }}>
            {squadOrder.map(squadKey => {
              const squad = SQUADS_DATA[squadKey];
              if (!squad) return null;
              const isOpen = openSquads.has(squadKey);
              const agents = Object.keys(squad.agents);
              const isActiveSquad = squadKey === activeSquad;
              return (
                <div key={squadKey}>
                  <button onClick={() => toggleSquad(squadKey)} style={{
                    width: "100%", display: "flex", alignItems: "center", gap: 8,
                    padding: "7px 16px", border: "none", background: isActiveSquad
                      ? "var(--color-background-info)" : "transparent",
                    cursor: "pointer", textAlign: "left"
                  }}>
                    <span style={{ fontSize: 14 }}>{squad.meta.emoji}</span>
                    <span style={{
                      fontSize: 12, fontWeight: 500,
                      color: isActiveSquad ? "var(--color-text-info)" : "var(--color-text-primary)",
                      flex: 1
                    }}>{squad.meta.label}</span>
                    <span style={{
                      fontSize: 10, color: "var(--color-text-tertiary)",
                      transform: isOpen ? "rotate(90deg)" : "none", transition: "transform 0.15s"
                    }}>{"▶"}</span>
                  </button>
                  {isOpen && agents.map(agentKey => {
                    const isActive = squadKey === activeSquad && agentKey === activeAgent;
                    const chief = isChief(agentKey);
                    return (
                      <button key={agentKey} onClick={() => selectAgent(squadKey, agentKey)} style={{
                        width: "100%", padding: "5px 16px 5px 36px", border: "none",
                        background: isActive ? "var(--color-background-secondary)" : "transparent",
                        cursor: "pointer", textAlign: "left", display: "flex", alignItems: "center", gap: 6
                      }}>
                        {chief && <span style={{ fontSize: 9, color: "var(--color-text-warning)" }}>{"★"}</span>}
                        <span style={{
                          fontSize: 12,
                          color: isActive ? "var(--color-text-primary)" : "var(--color-text-secondary)",
                          fontWeight: isActive ? 500 : 400
                        }}>{getAgentDisplayName(agentKey)}</span>
                      </button>
                    );
                  })}
                </div>
              );
            })}
          </div>
        </div>
      )}
      <div style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
        <div style={{
          padding: "12px 20px", background: "var(--color-background-primary)",
          borderBottom: "0.5px solid var(--color-border-tertiary)",
          display: "flex", alignItems: "center", gap: 12
        }}>
          <button onClick={() => setSidebarOpen(v => !v)} style={{
            border: "0.5px solid var(--color-border-secondary)", borderRadius: "var(--border-radius-md)",
            background: "transparent", padding: "4px 8px", cursor: "pointer",
            fontSize: 12, color: "var(--color-text-secondary)"
          }}>{"☰"}</button>
          <div style={{
            width: 36, height: 36, borderRadius: "50%",
            background: "var(--color-background-info)",
            display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16
          }}>{squadEmoji}</div>
          <div>
            <p style={{ margin: 0, fontWeight: 500, fontSize: 14, color: "var(--color-text-primary)" }}>{agentLabel}</p>
            <p style={{ margin: 0, fontSize: 11, color: "var(--color-text-tertiary)" }}>{squadLabel}</p>
          </div>
          {messages.length > 0 && (
            <button onClick={() => setMessages([])} style={{
              marginLeft: "auto", border: "0.5px solid var(--color-border-secondary)",
              borderRadius: "var(--border-radius-md)", background: "transparent",
              padding: "4px 10px", cursor: "pointer", fontSize: 11,
              color: "var(--color-text-secondary)"
            }}>Limpar</button>
          )}
        </div>
        <div style={{ flex: 1, overflowY: "auto", padding: "20px" }}>
          {messages.length === 0 && (
            <div style={{ textAlign: "center", paddingTop: "15vh" }}>
              <div style={{ fontSize: 40, marginBottom: 12 }}>{squadEmoji}</div>
              <p style={{ fontWeight: 500, fontSize: 16, color: "var(--color-text-primary)", margin: "0 0 6px" }}>{agentLabel}</p>
              <p style={{ fontSize: 13, color: "var(--color-text-tertiary)", maxWidth: 320, margin: "0 auto" }}>
                {currentSquad?.meta?.desc}
              </p>
            </div>
          )}
          {messages.map((msg, i) => (
            <div key={i} style={{
              marginBottom: 16, display: "flex",
              justifyContent: msg.role === "user" ? "flex-end" : "flex-start"
            }}>
              {msg.role === "assistant" && (
                <div style={{
                  width: 28, height: 28, borderRadius: "50%",
                  background: "var(--color-background-info)",
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontSize: 14, marginRight: 8, flexShrink: 0, marginTop: 2
                }}>{squadEmoji}</div>
              )}
              <div style={{
                maxWidth: "72%",
                background: msg.role === "user"
                  ? "var(--color-background-info)" : "var(--color-background-primary)",
                border: "0.5px solid var(--color-border-tertiary)",
                borderRadius: "var(--border-radius-lg)", padding: "10px 14px",
                fontSize: 14, lineHeight: 1.6,
                color: msg.role === "user" ? "var(--color-text-info)" : "var(--color-text-primary)",
                whiteSpace: "pre-wrap"
              }}>{msg.content}</div>
            </div>
          ))}
          {loading && (
            <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 16 }}>
              <div style={{
                width: 28, height: 28, borderRadius: "50%",
                background: "var(--color-background-info)",
                display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14
              }}>{squadEmoji}</div>
              <div style={{
                background: "var(--color-background-primary)",
                border: "0.5px solid var(--color-border-tertiary)",
                borderRadius: "var(--border-radius-lg)", padding: "10px 14px",
                fontSize: 13, color: "var(--color-text-tertiary)"
              }}>Pensando...</div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>
        <div style={{
          padding: "12px 20px 16px",
          background: "var(--color-background-primary)",
          borderTop: "0.5px solid var(--color-border-tertiary)"
        }}>
          <div style={{ display: "flex", gap: 8 }}>
            <textarea ref={inputRef} value={input} onChange={e => setInput(e.target.value)}
              onKeyDown={handleKey} placeholder={"Fale com " + agentLabel + "..."}
              rows={1} style={{
                flex: 1, resize: "none", fontSize: 14, padding: "8px 12px",
                borderRadius: "var(--border-radius-md)",
                border: "0.5px solid var(--color-border-secondary)",
                background: "var(--color-background-secondary)",
                color: "var(--color-text-primary)",
                outline: "none", lineHeight: 1.5,
                fontFamily: "var(--font-sans)"
              }} />
            <button onClick={sendMessage} disabled={loading || !input.trim()} style={{
              padding: "8px 16px", borderRadius: "var(--border-radius-md)",
              border: "0.5px solid var(--color-border-secondary)",
              background: input.trim() && !loading ? "var(--color-background-info)" : "var(--color-background-secondary)",
              color: input.trim() && !loading ? "var(--color-text-info)" : "var(--color-text-tertiary)",
              cursor: input.trim() && !loading ? "pointer" : "not-allowed",
              fontSize: 13, fontWeight: 500
            }}>Enviar</button>
          </div>
          <p style={{ margin: "6px 0 0", fontSize: 11, color: "var(--color-text-tertiary)" }}>
            Enter para enviar - Shift+Enter nova linha - {"★"} = orquestrador do squad
          </p>
        </div>
      </div>
    </div>
  );
}
