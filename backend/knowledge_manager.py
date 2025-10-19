#!/usr/bin/env python3
"""
Enhanced Knowledge Base Manager
Semantic search and retrieval for TEP knowledge base
Adapted from TEP_interactive_LLM-main for backend integration
"""

import os
import re
import json
from typing import List, Dict, Any, Optional, Tuple
from dataclasses import dataclass
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

@dataclass
class KnowledgeChunk:
    id: str
    content: str
    source_document: str
    section: str
    keywords: List[str]
    relevance_score: float = 0.0
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            'id': self.id,
            'content': self.content,
            'source_document': self.source_document,
            'section': self.section,
            'keywords': self.keywords,
            'relevance_score': self.relevance_score
        }

class EnhancedKnowledgeManager:
    """
    Enhanced knowledge base manager with semantic search capabilities
    Uses existing TEP knowledge base with improved retrieval
    """
    
    def __init__(self, knowledge_base_path: str = None):
        # Auto-detect knowledge base path
        if knowledge_base_path is None:
            # Use local RAG folder in TEP_control directory
            backend_dir = Path(__file__).parent
            tep_control_dir = backend_dir.parent
            local_kb_path = tep_control_dir / "RAG" / "converted_markdown"

            if local_kb_path.exists() and (local_kb_path / "TEP_Thesis.md").exists():
                knowledge_base_path = str(local_kb_path.resolve())  # Use absolute path
                logger.info(f"✅ Found knowledge base at: {knowledge_base_path}")
            else:
                logger.warning(f"⚠️ Knowledge base not found at {local_kb_path}, using empty knowledge base")
                knowledge_base_path = "."
        
        self.knowledge_base_path = Path(knowledge_base_path)
        self.documents: Dict[str, str] = {}
        self.chunks: List[KnowledgeChunk] = []
        self.keyword_index: Dict[str, List[str]] = {}  # keyword -> chunk_ids
        
        # TEP-specific knowledge patterns
        self.tep_patterns = {
            'equipment': [
                'reactor', 'separator', 'compressor', 'condenser', 'stripper',
                'heat exchanger', 'valve', 'pump', 'tank', 'vessel'
            ],
            'variables': [
                'temperature', 'pressure', 'flow', 'level', 'composition',
                'XMEAS', 'XMV', 'IDV', 'setpoint'
            ],
            'faults': [
                'leak', 'blockage', 'fouling', 'degradation', 'failure',
                'malfunction', 'deviation', 'upset', 'disturbance'
            ],
            'analysis_methods': [
                'PCA', 'T2 statistic', 'multivariate', 'statistical',
                'correlation', 'regression', 'classification'
            ]
        }
        
        self.load_knowledge_base()
        if self.documents:
            self.create_chunks()
            self.build_keyword_index()
    
    def load_knowledge_base(self):
        """Load knowledge base documents"""
        try:
            # Load TEP thesis
            tep_thesis_path = self.knowledge_base_path / "TEP_Thesis.md"
            if tep_thesis_path.exists():
                with open(tep_thesis_path, 'r', encoding='utf-8') as f:
                    self.documents['TEP_Thesis'] = f.read()
                logger.info(f"✅ Loaded TEP_Thesis.md ({len(self.documents['TEP_Thesis'])} chars)")
            
            # Load fault detection thesis
            fault_thesis_path = self.knowledge_base_path / "chaiwatanodom-pchaiwat-phd-cheme-2021-thesis.md"
            if fault_thesis_path.exists():
                with open(fault_thesis_path, 'r', encoding='utf-8') as f:
                    self.documents['Fault_Detection_Thesis'] = f.read()
                logger.info(f"✅ Loaded Fault_Detection_Thesis.md ({len(self.documents['Fault_Detection_Thesis'])} chars)")
            
            logger.info(f"📚 Total documents loaded: {len(self.documents)}")
            
        except Exception as e:
            logger.error(f"❌ Error loading knowledge base: {e}")
    
    def create_chunks(self, chunk_size: int = 1000, overlap: int = 200):
        """Create searchable chunks from documents"""
        self.chunks = []
        
        for doc_name, content in self.documents.items():
            # Split by sections first (markdown headers)
            sections = self._split_by_sections(content)
            
            for section_title, section_content in sections:
                # Further split large sections into chunks
                if len(section_content) > chunk_size:
                    text_chunks = self._split_text_with_overlap(section_content, chunk_size, overlap)
                else:
                    text_chunks = [section_content]
                
                for i, chunk_text in enumerate(text_chunks):
                    if len(chunk_text.strip()) < 50:  # Skip very short chunks
                        continue
                    
                    chunk_id = f"{doc_name}_{section_title}_{i}"
                    keywords = self._extract_keywords(chunk_text)
                    
                    chunk = KnowledgeChunk(
                        id=chunk_id,
                        content=chunk_text.strip(),
                        source_document=doc_name,
                        section=section_title,
                        keywords=keywords
                    )
                    
                    self.chunks.append(chunk)
        
        logger.info(f"📄 Created {len(self.chunks)} knowledge chunks")
    
    def _split_by_sections(self, content: str) -> List[Tuple[str, str]]:
        """Split document by markdown sections"""
        sections = []
        lines = content.split('\n')
        current_section = "Introduction"
        current_content = []
        
        for line in lines:
            # Check for markdown headers
            if line.startswith('#'):
                # Save previous section
                if current_content:
                    sections.append((current_section, '\n'.join(current_content)))
                
                # Start new section
                current_section = line.strip('#').strip()
                current_content = []
            else:
                current_content.append(line)
        
        # Add last section
        if current_content:
            sections.append((current_section, '\n'.join(current_content)))
        
        return sections
    
    def _split_text_with_overlap(self, text: str, chunk_size: int, overlap: int) -> List[str]:
        """Split text into overlapping chunks"""
        chunks = []
        start = 0
        
        while start < len(text):
            end = start + chunk_size
            
            # Try to break at sentence boundary
            if end < len(text):
                # Look for sentence ending within overlap range
                for i in range(end - overlap, end):
                    if i < len(text) and text[i] in '.!?':
                        end = i + 1
                        break
            
            chunk = text[start:end]
            if chunk.strip():
                chunks.append(chunk)
            
            start = end - overlap
            if start >= len(text):
                break
        
        return chunks
    
    def _extract_keywords(self, text: str) -> List[str]:
        """Extract TEP-relevant keywords from text"""
        keywords = []
        text_lower = text.lower()
        
        # Extract TEP-specific terms
        for category, terms in self.tep_patterns.items():
            for term in terms:
                if term.lower() in text_lower:
                    keywords.append(term)
        
        # Extract technical terms (capitalized words, acronyms)
        technical_terms = re.findall(r'\b[A-Z]{2,}\b|\b[A-Z][a-z]+(?:\s+[A-Z][a-z]+)*\b', text)
        keywords.extend([term for term in technical_terms if len(term) > 2])
        
        # Extract numbers with units (temperatures, pressures, etc.)
        units_pattern = r'\d+\.?\d*\s*(?:°C|°F|K|bar|psi|kPa|MPa|L/min|m³/h|kg/h)'
        unit_matches = re.findall(units_pattern, text)
        keywords.extend(unit_matches)
        
        return list(set(keywords))  # Remove duplicates
    
    def build_keyword_index(self):
        """Build inverted index for fast keyword lookup"""
        self.keyword_index = {}
        
        for chunk in self.chunks:
            for keyword in chunk.keywords:
                keyword_lower = keyword.lower()
                if keyword_lower not in self.keyword_index:
                    self.keyword_index[keyword_lower] = []
                self.keyword_index[keyword_lower].append(chunk.id)
        
        logger.info(f"🔍 Built keyword index with {len(self.keyword_index)} terms")
    
    def search_knowledge(self, query: str, max_results: int = 5, 
                        min_relevance: float = 0.1) -> List[KnowledgeChunk]:
        """
        Search knowledge base with enhanced relevance scoring
        """
        if not self.chunks:
            logger.warning("⚠️ No knowledge chunks available")
            return []
        
        query_lower = query.lower()
        query_keywords = self._extract_query_keywords(query)
        
        # Score all chunks
        chunk_scores = {}
        
        for chunk in self.chunks:
            score = self._calculate_relevance_score(chunk, query_lower, query_keywords)
            if score >= min_relevance:
                chunk_scores[chunk.id] = score
                chunk.relevance_score = score
        
        # Sort by relevance score
        sorted_chunks = sorted(
            [chunk for chunk in self.chunks if chunk.id in chunk_scores],
            key=lambda x: x.relevance_score,
            reverse=True
        )
        
        return sorted_chunks[:max_results]
    
    def _extract_query_keywords(self, query: str) -> List[str]:
        """Extract keywords from search query"""
        keywords = []
        
        # Extract TEP-specific terms from query
        for category, terms in self.tep_patterns.items():
            for term in terms:
                if term.lower() in query.lower():
                    keywords.append(term)
        
        # Extract important words (nouns, adjectives)
        words = re.findall(r'\b\w{3,}\b', query.lower())
        
        # Filter out common words
        stop_words = {'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had', 'her', 'was', 'one', 'our', 'out', 'day', 'get', 'has', 'him', 'his', 'how', 'man', 'new', 'now', 'old', 'see', 'two', 'way', 'who', 'boy', 'did', 'its', 'let', 'put', 'say', 'she', 'too', 'use'}
        
        keywords.extend([word for word in words if word not in stop_words])

        return list(set(keywords))

    def _calculate_relevance_score(self, chunk: KnowledgeChunk, query_lower: str,
                                 query_keywords: List[str]) -> float:
        """Calculate relevance score for a chunk"""
        score = 0.0
        content_lower = chunk.content.lower()

        # Exact phrase matching (highest weight)
        if query_lower in content_lower:
            score += 1.0

        # Keyword matching
        keyword_matches = 0
        for keyword in query_keywords:
            if keyword.lower() in content_lower:
                keyword_matches += 1
                # Bonus for TEP-specific terms
                if any(keyword.lower() in [t.lower() for terms in self.tep_patterns.values() for t in terms]):
                    score += 0.3
                else:
                    score += 0.2

        # Keyword density bonus
        if query_keywords:
            keyword_density = keyword_matches / len(query_keywords)
            score += keyword_density * 0.5

        # Section relevance bonus
        section_lower = chunk.section.lower()
        if any(keyword.lower() in section_lower for keyword in query_keywords):
            score += 0.2

        # Length penalty for very long chunks (prefer concise answers)
        if len(chunk.content) > 2000:
            score *= 0.9

        return min(score, 2.0)  # Cap maximum score

    def get_context_for_hypothesis(self, hypothesis: str, ruled_out: List[str] = None) -> List[KnowledgeChunk]:
        """Get relevant context for a specific hypothesis"""
        # Create enhanced query that excludes ruled-out causes
        query = hypothesis

        if ruled_out:
            # Add negative context to avoid ruled-out causes
            excluded_terms = " ".join(ruled_out)
            query += f" NOT {excluded_terms}"

        return self.search_knowledge(query, max_results=3)

    def get_alternative_causes(self, current_hypotheses: List[str],
                             anomaly_symptoms: List[str]) -> List[KnowledgeChunk]:
        """Find alternative causes based on symptoms, excluding current hypotheses"""
        # Build query from symptoms
        symptoms_query = " ".join(anomaly_symptoms)

        # Search for alternative explanations
        results = self.search_knowledge(symptoms_query, max_results=10)

        # Filter out results that match current hypotheses
        filtered_results = []
        for result in results:
            content_lower = result.content.lower()

            # Check if this result suggests causes already considered
            is_duplicate = False
            for hypothesis in current_hypotheses:
                if any(word in content_lower for word in hypothesis.lower().split() if len(word) > 3):
                    is_duplicate = True
                    break

            if not is_duplicate:
                filtered_results.append(result)

        return filtered_results[:5]

    def get_maintenance_guidance(self, equipment: str, issue: str) -> List[KnowledgeChunk]:
        """Get maintenance and troubleshooting guidance"""
        query = f"{equipment} {issue} maintenance troubleshooting repair"
        return self.search_knowledge(query, max_results=3)

    def get_statistics(self) -> Dict[str, Any]:
        """Get knowledge base statistics"""
        return {
            'total_documents': len(self.documents),
            'total_chunks': len(self.chunks),
            'total_keywords': len(self.keyword_index),
            'average_chunk_size': sum(len(chunk.content) for chunk in self.chunks) / len(self.chunks) if self.chunks else 0,
            'documents': {name: len(content) for name, content in self.documents.items()}
        }

