#!/usr/bin/env python3
"""
Compare spec field definitions to actual implementation.

Usage:
  python scripts/compare-spec-to-implementation.py \\
    specs/evv/AGMT-001.yaml \\
    ../evv/addons/evv_agreements/models/
    
Exit codes:
  0 = Perfect match
  1 = Mismatches found
"""

import yaml
import re
import sys
import os
from pathlib import Path

def parse_spec(spec_file):
    """Extract field definitions from spec YAML"""
    with open(spec_file, 'r') as f:
        spec = yaml.safe_load(f)
    
    models = {}
    for model in spec.get('models', []):
        model_name = model['name']
        fields = {}
        for field in model.get('fields', []):
            fields[field['name']] = {
                'type': field['type'],
                'required': field.get('required', False)
            }
        models[model_name] = fields
    
    return models

def parse_python_model(file_path):
    """Extract field definitions from Python model file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Extract field definitions
    # Pattern: field_name = fields.Type(...)
    pattern = r'^\s+(\w+)\s*=\s*fields\.(\w+)\('
    fields = {}
    
    for match in re.finditer(pattern, content, re.MULTILINE):
        field_name = match.group(1)
        field_type = match.group(2)
        fields[field_name] = {'type': field_type}
    
    return fields

def compare_models(spec_models, impl_dir):
    """Compare spec models to implementation"""
    print("=" * 80)
    print("SPEC vs IMPLEMENTATION COMPARISON")
    print("=" * 80)
    
    all_match = True
    
    for model_name, spec_fields in spec_models.items():
        print(f"\n📋 Model: {model_name}")
        print("-" * 80)
        
        # Determine which file to check
        if model_name == 'res.partner':
            impl_file = os.path.join(impl_dir, 'partner.py')
        elif model_name == 'service.agreement':
            impl_file = os.path.join(impl_dir, 'service_agreement.py')
        else:
            print(f"  ⚠️  Unknown model: {model_name}")
            continue
        
        if not os.path.exists(impl_file):
            print(f"  ❌ Implementation file not found: {impl_file}")
            all_match = False
            continue
        
        # Parse implementation
        impl_fields = parse_python_model(impl_file)
        
        # Compare fields
        spec_field_names = set(spec_fields.keys())
        impl_field_names = set(impl_fields.keys())
        
        # Check for matches
        matching = spec_field_names & impl_field_names
        missing = spec_field_names - impl_field_names
        extra = impl_field_names - spec_field_names
        
        print(f"  ✅ Matching fields: {len(matching)}/{len(spec_field_names)}")
        
        if missing:
            print(f"\n  ❌ MISSING in implementation (defined in spec):")
            for field in sorted(missing):
                req = " (REQUIRED)" if spec_fields[field]['required'] else ""
                print(f"     - {field}{req}")
            all_match = False
        
        if extra:
            print(f"\n  ⚠️  EXTRA in implementation (not in spec):")
            for field in sorted(extra):
                print(f"     - {field}")
            # Extra fields are a warning, not an error
        
        # Show matching fields with types
        if matching and not missing:
            print(f"\n  ✅ All spec fields implemented correctly:")
            for field in sorted(matching):
                spec_type = spec_fields[field]['type']
                impl_type = impl_fields[field]['type']
                type_match = "✅" if spec_type == impl_type else "⚠️"
                req = " (REQ)" if spec_fields[field]['required'] else ""
                print(f"     {type_match} {field:<30} Spec: {spec_type:<12} Impl: {impl_type:<12}{req}")
    
    print("\n" + "=" * 80)
    if all_match:
        print("✅ RESULT: Implementation matches spec perfectly!")
        print("=" * 80)
        return 0
    else:
        print("❌ RESULT: Mismatches found - see details above")
        print("=" * 80)
        return 1

def main():
    if len(sys.argv) < 3:
        print("Usage: python compare-spec-to-implementation.py SPEC_FILE MODELS_DIR")
        sys.exit(1)
    
    spec_file = sys.argv[1]
    models_dir = sys.argv[2]
    
    if not os.path.exists(spec_file):
        print(f"❌ Error: Spec file not found: {spec_file}")
        sys.exit(1)
    
    if not os.path.exists(models_dir):
        print(f"❌ Error: Models directory not found: {models_dir}")
        sys.exit(1)
    
    print(f"📄 Spec: {spec_file}")
    print(f"📁 Implementation: {models_dir}")
    
    spec_models = parse_spec(spec_file)
    exit_code = compare_models(spec_models, models_dir)
    
    sys.exit(exit_code)

if __name__ == '__main__':
    main()

