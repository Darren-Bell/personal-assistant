# OpenClaw Wiki Schema

## Directory Structure
- `sources/`: Original documents (immutable)
- `entities/`: People, places, organizations
- `concepts/`: Topics and abstract ideas
- `logs/`: Activity history

## Page Format
```json
{
  "title": "Page Title",
  "summary": "1-sentence description",
  "facts": ["Atomic knowledge units"],
  "sources": ["/sources/doc1.md"],
  "related": ["/entities/related_entity.md"]
}
```

## Workflows
- **Ingest**: Process new sources → create entity/concept pages
- **Query**: Answer using wiki first, then external sources
- **Lint**: Weekly consistency checks