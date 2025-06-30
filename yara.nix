{stdenv, lib, signature-base, ...}: 
let 
  fs = lib.fileset; 
  root = /. + (builtins.unsafeDiscardStringContext signature-base);
in stdenv.mkDerivation {
	name = "yara-sigs";
	src = lib.fileset.toSource {
	  inherit root;
	  fileset = fs.difference (fs.fileFilter (file: file.hasExt "yar") root) (fs.unions (lib.lists.imap0 (i: p: root + p) [
    "/yara/generic_anomalies.yar"
    "/yara/general_cloaking.yar"
    "/yara/gen_webshells_ext_vars.yar"
    "/yara/thor_inverse_matches.yar"
    "/yara/yara_mixed_ext_vars.yar"
    "/yara/configured_vulns_ext_vars.yar"
    "/yara/gen_fake_amsi_dll.yar"
    "/yara/expl_citrix_netscaler_adc_exploitation_cve_2023_3519.yar"
    "/yara/yara-rules_vuln_drivers_strict_renamed.yar"
    "/yara/gen_vcruntime140_dll_sideloading.yar"
    "/yara/gen_mal_3cx_compromise_mar23.yar"
    "/yara/expl_connectwise_screenconnect_vuln_feb24.yar"
    "/yara/gen_susp_obfuscation.yar"
	  ]));
	};
	installPhase = ''
	set -e
	mkdir -p $out/bin $out/yara
	cp -av $src/yara $out/
	cat > yara-sigs <<- EOL
	#!/usr/bin/env bash
	yara \$(find $out/yara -name "*.yar") -r \$@
	EOL
	chmod +x yara-sigs
	cp yara-sigs $out/bin/
	'';
}
