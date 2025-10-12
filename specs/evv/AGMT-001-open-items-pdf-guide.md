# Guide: Creating Fillable PDF from Open Items Document

## Quick Start

Convert `AGMT-001-open-items.md` to a fillable PDF for SME distribution.

---

## Option 1: Microsoft Word → PDF (Recommended - Easiest)

### Steps:

1. **Convert Markdown to Word**
   - Open `AGMT-001-open-items.md` in VS Code or text editor
   - Use Pandoc: `pandoc AGMT-001-open-items.md -o AGMT-001-open-items.docx`
   - Or use online converter: https://www.markdowntoword.com/

2. **Add Form Fields in Word**
   - Open `.docx` file in Microsoft Word
   - Go to `Developer` tab → `Design Mode`
   - Add checkboxes for multiple choice questions
   - Add text fields for "SME Notes" sections
   - Add text fields for "SME Input Requested" sections

3. **Export to PDF**
   - File → Save As → PDF
   - Check "Create PDF Form" option

### Form Field Locations:

**For each OI (Open Item) section, add:**
- Checkbox group for "SME Decision"
- Rich Text field for "SME Notes" (3-4 lines)
- Checkbox group for "Implementation Status"

---

## Option 2: Adobe Acrobat (Most Professional)

### Steps:

1. **Convert Markdown to PDF**
   - Use Pandoc: `pandoc AGMT-001-open-items.md -o AGMT-001-open-items.pdf`
   - Or print to PDF from any markdown viewer

2. **Add Form Fields in Adobe Acrobat Pro**
   - Open PDF in Adobe Acrobat Pro
   - Tools → Prepare Form → Auto-detect form fields (or manual)
   - Acrobat will attempt to detect checkboxes and text areas
   - Manually adjust field positions and sizes
   - Set field properties (required, tooltips, validation)

3. **Save as Fillable PDF**
   - File → Save
   - Test by opening in Adobe Reader

### Form Field Configuration:

**OI-001 (PHI Classification):**
- Radio button group: `phi_decision`
  - Option 1: "Mark as PHI"
  - Option 2: "Do NOT mark as PHI"
  - Option 3: "Other"
- Text field: `phi_other` (if "Other" selected)
- Text area: `phi_notes` (multiline, 3 rows)
- Checkbox group: `phi_status`
  - "Not Started" | "In Progress" | "Completed"

**Repeat pattern for OI-002 through OI-006.**

---

## Option 3: Google Docs → PDF (Cloud-Based)

### Steps:

1. **Convert Markdown to Google Doc**
   - Upload `AGMT-001-open-items.md` to Google Drive
   - Right-click → Open with → Google Docs
   - Clean up formatting

2. **Add Form Elements**
   - Insert → Checkbox (for decision options)
   - Insert → Table (for notes sections - easier to fill)
   - Format as needed

3. **Export to PDF**
   - File → Download → PDF Document (.pdf)

**Note:** Google Docs doesn't create true "fillable PDFs" but creates a clean layout that can be printed and filled manually or annotated in PDF readers.

---

## Option 4: Automated Script (For Recurring Use)

### Setup (One-Time):

Create a Python script using `reportlab` or `pdfrw` to generate fillable PDFs programmatically:

```python
# generate_sme_pdf.py
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfform

# Parse markdown, extract questions, generate PDF with form fields
# (Script template - can be expanded)
```

### Benefits:
- Consistent formatting
- Easy to regenerate as open items change
- Can be integrated into workflow automation

---

## Recommended Workflow for Your Project

### Initial Setup:
1. Use **Option 1 (Word → PDF)** for first iteration (fastest, most accessible)
2. Create template once with all form fields
3. Save as `.docx` template for future use

### For Each New Story:
1. Generate markdown open items document (as we just did)
2. Replace content in Word template
3. Adjust form fields if needed
4. Export to PDF
5. Distribute to SMEs

### SME Returns PDF:
1. Extract data manually or use form data export
2. Update markdown document with SME decisions
3. Create GitHub issues for any implementation changes needed

---

## Form Field Naming Convention

Use consistent naming for easy data extraction:

```
OI-[NUMBER]_decision       # Radio/checkbox group for main decision
OI-[NUMBER]_other          # Text field for "Other" option
OI-[NUMBER]_notes          # Text area for SME notes
OI-[NUMBER]_status         # Checkbox group for implementation status
```

**Example:**
- `OI-001_decision`
- `OI-001_notes`
- `OI-001_status`

---

## Alternative: Survey Tool

If fillable PDFs prove cumbersome, consider:

### Google Forms
- Create form with questions matching open items
- SMEs fill online
- Responses auto-populate spreadsheet
- Easy to analyze and export

### Microsoft Forms / SurveyMonkey
- Similar to Google Forms
- Can export to PDF for records

### Pros:
- No PDF software needed
- Data automatically structured
- Can track completion status
- Can send reminders

### Cons:
- Requires internet access
- SMEs need to learn new tool
- Less "official" feeling than PDF

---

## Next Steps for You

1. **Choose your tool** (Recommendation: Start with Word)
2. **Create fillable PDF** from `AGMT-001-open-items.md`
3. **Test with one SME** to validate usability
4. **Get feedback** on format/questions
5. **Iterate** on template based on feedback
6. **Standardize** process for future stories

---

## Files Created

- `AGMT-001-open-items.md` - Source markdown (master copy)
- `AGMT-001-open-items-pdf-guide.md` - This guide
- `AGMT-001-open-items.pdf` - (You create) Fillable PDF for SMEs
- `AGMT-001-open-items-completed.pdf` - (SME returns) Filled responses

---

**Good luck! This should streamline your SME consultation process significantly.**

