# Meds Screen Redesign

_Created: 2026-03-29_

## Problem

The meds screen shows only medicine names with no dosage, purpose, or identifying details.
Morning list was missing Simvastatin and Mag Glycinate. Evening list had no specific med names.
No session title in the AppBar.

## Design

### Data (from care plan)

**Morning (Oggend Medisyne):**
| Medicine | Dosage | Purpose (Afrikaans) |
|----------|--------|---------------------|
| Zetomax | 10mg | Verlaag cholesterol |
| Lansoloc | 15mg | Maag beskermer |
| Clopiwin | 75mg | Voorkom bloedklonte |

**Evening (Aand Medisyne):**
| Medicine | Dosage | Purpose (Afrikaans) |
|----------|--------|---------------------|
| Simvastatin | 10mg | Verlaag cholesterol (statien) |
| Mag Glycinate | 75mg | Magnesium — brein & are |

**B12 (every 2 weeks):**
| Medicine | Dosage | Purpose (Afrikaans) |
|----------|--------|---------------------|
| B12 | 1000µg | B12 inspuiting |

### UI Changes

1. AppBar title shows session name: "Oggend Medisyne" / "Aand Medisyne" / "B12 Inspuiting"
2. Each medicine displayed as a card with: name + dosage, Afrikaans purpose description
3. Single confirm button kept (not individual checkboxes)
4. Pill appearance descriptions deferred to later

### Approach

- Replace `List<String> _medNames` with a richer data model containing name, dosage, purpose
- Render each med as a styled card/tile
- Add session title to AppBar
