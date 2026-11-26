CREATE TABLE IF NOT EXISTS publications (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL,
    category VARCHAR(100) NOT NULL,
    isbn VARCHAR(50),
    summary TEXT,
    content TEXT,
    cover_url VARCHAR(255)
);

INSERT INTO publications (id, title, author, type, category, isbn, summary, content, cover_url) VALUES
(
  1,
  'Operating Systems: Internals and Design Principles',
  'William Stallings',
  'TEXTBOOK',
  'Computer Science',
  '978-0133805918',
  'A comprehensive exploration of modern operating systems, process management, memory virtual memory, and concurrency.',
  'Chapter 1: Introduction to Operating Systems.\n\nAn Operating System (OS) acts as an intermediary between the user of a computer and the computer hardware. The purpose of an operating system is to provide an environment in which a user can execute programs conveniently and efficiently.\n\nKey Core Functions:\n1. Process Management: CPU scheduling, synchronization, and deadlock prevention.\n2. Memory Management: Paging, segmentation, and virtual address spaces.\n3. Storage & I/O: File system abstraction and device driver interfaces.',
  'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&auto=format&fit=crop&q=80'
),
(
  2,
  'Database System Concepts (8th Edition)',
  'Silberschatz, Korth, Sudarshan',
  'TEXTBOOK',
  'Data Engineering',
  '978-0078022159',
  'The authoritative reference on relational database theory, query optimization, ACID transactions, and distributed databases.',
  'Chapter 1: Relational Model Foundations.\n\nA database system is a collection of interrelated data and a set of programs that allow users to access and modify these data. A major purpose of a database system is to provide users with an abstract view of the data.\n\nACID Properties:\n- Atomicity: All or nothing execution.\n- Consistency: Preservation of database invariants.\n- Isolation: Concurrent transactions do not interfere.\n- Durability: Committed updates survive system crashes.',
  'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=600&auto=format&fit=crop&q=80'
),
(
  3,
  'University Physics with Modern Physics',
  'Young and Freedman',
  'TEXTBOOK',
  'Physics',
  '978-0135159553',
  'Classic university foundation covering Newtonian mechanics, thermodynamics, electromagnetism, and quantum physics.',
  'Chapter 1: Units, Physical Quantities, and Vectors.\n\nPhysics is an experimental science. Physicists observe the phenomena of nature and try to find patterns and principles that relate these phenomena. These patterns are called physical theories or physical laws.\n\nCore Principles:\n- Newton''s Laws of Motion\n- Conservation of Energy and Momentum\n- Thermodynamic Systems and Entropy',
  'https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=600&auto=format&fit=crop&q=80'
),
(
  4,
  'Cloud Computing & Distributed Systems in Practice',
  'Rajkumar Buyya',
  'TEXTBOOK',
  'DevOps & Cloud',
  '978-0128000564',
  'Architecture patterns for scalable cloud services, containers, Kubernetes clustering, and horizontal elasticity.',
  'Chapter 1: The Cloud Paradigm.\n\nCloud computing delivers computing services—including servers, storage, databases, networking, and software—over the Internet to offer faster innovation, flexible resources, and economies of scale.\n\nKey Concepts:\n- Horizontal vs. Vertical Scaling\n- Microservices vs. Monolithic Architectures\n- High Availability, Replication, and Fault Tolerance',
  'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600&auto=format&fit=crop&q=80'
),
(
  5,
  'The Daily Tech Chronicle - Morning Edition',
  'Cengage Editorial Board',
  'NEWSPAPER',
  'Technology News',
  'ISSN-2490-1120',
  'Daily technology updates covering cloud infrastructure, Kubernetes v1.37 advancements, and AI agent breakthroughs.',
  'FRONT PAGE: Cloud-Native Architectures Surge Across Higher Education.\n\nLeading universities and enterprise research institutions are completing migrations toward containerized platforms. The transition enables institutions to run dynamic, on-demand compute environments while cutting operational overhead by up to 45%.\n\nKey Highlights Today:\n- Kubernetes introduces enhanced scheduler efficiency for mixed AI/Java workloads.\n- Blue/Green deployments become standard policy across campus digital libraries.\n- Student engagement increases by 60% with digital e-reader platforms.',
  'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=600&auto=format&fit=crop&q=80'
),
(
  6,
  'The Wall Street Science Review',
  'Global Academic Press',
  'NEWSPAPER',
  'Business & Science',
  'ISSN-1922-8831',
  'Market analysis and academic publishing trends in the digital learning and textbook industry.',
  'BUSINESS INSIGHT: The Shift from Print to Subscription Platforms.\n\nInstitutional subscriptions models like Cengage Unlimited continue to transform student course materials. Rather than purchasing individual $200 textbooks, students access full academic libraries across subjects through single-sign-on platforms.\n\nAnalysis:\n- 78% of engineering students prefer searchable digital publications.\n- Seamless progress tracking across devices drives higher completion rates.',
  'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=600&auto=format&fit=crop&q=80'
),
(
  7,
  'Zero-Downtime Blue/Green Deployments in Cloud-Native Kubernetes',
  'IEEE Cloud Computing Series',
  'RESEARCH_PAPER',
  'Cloud Architecture',
  'DOI:10.1109/MCC.2025.109',
  'Peer-reviewed paper analyzing canary versus blue/green traffic cutovers in containerized enterprise web applications.',
  'ABSTRACT:\n\nHigh-availability cloud web services demand zero user-facing downtime during production updates. This paper evaluates the performance characteristics of label-selector based Blue/Green cutovers versus rolling deployments under heavy concurrent traffic.\n\nEmpirical benchmarks show zero HTTP 5xx errors during DNS/Service label switching, preserving active TCP connections and session states across multi-tier database configurations.',
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600&auto=format&fit=crop&q=80'
)
ON CONFLICT (id) DO NOTHING;

SELECT setval('publications_id_seq', (SELECT MAX(id) FROM publications));