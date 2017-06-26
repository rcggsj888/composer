ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.8.0
docker tag hyperledger/composer-playground:0.8.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� R�PY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z@���WU�>ޫW�^U)�|��l�LÆ!S�z�h�J����0���MpL�/.���(��X>�'G� �ʿڶ#Y <p,���W�M��=��l����2�LQ6�:��5����ƿtGRuh�R���$RmI���ҠҀV�R�4,�v� �W�f��L �Q-CoA��#�
�b�"��R��F6���" x�@+�.�5'e�:�T��e�U�k�nju�f�2�"�BF�n0OH9��pK\��G�-[�������6H�a��h:!z9w����ە��cX+�4Z�o�H�Y�C%d����4�Je��X�R��F�~3F���h[��a��Z$��3�ej0��ZK0<C�$�
y;B�ܔP��[�����mf��`5�\�8�!Kc���㘈rY&:6�U��ч�w1B�	gjU����씷���`���0�����;����#:EQW�^��T�*i3�TQ'(-��K�Pݩ���������W�E]~����	?��p�<s��KZ_���#��oa��툐;!,����yx�O$�����?�s���� �wN�����1��@�R���NPa�y�2H��W�?���?����Q�'b\b�����z�&�M�6ږ��)��GQ-,
����P�<�v�)�����h�����*�+r����`�!
�0�����;���������a���|����c���b��]i�aY>N�?��?� b�O,�.���_��vt0����0
f�Q7tض5Z�B�l� ����<�pH�B��nXh5ց�ab��?m�m��<LK�H�ѱڐIm�iXCF[Se�ۤF�M�܈�C�?�rN'5C>��ZL�kL�bhm\%/)�z5��V��0�K�B��"�qq�:a&$ifS
��>��X؄��-��j�0���55�6s��Z[Ք�d�M�CH�m�����X ��@�|�j����`LRx4�zI5�U7��|c��z؋Y�駉�ʒ������5�?A��dw�*���c��7 �Q�X�����`-��:1��)9�D�4"�-�2:B`�u]���6�'��|��zGQEv��S�!`� t��R���&�,� �Z4޾�Y�HB@�i z���P���� |�}"h�F���aK�[���L�UT87X�,����2�d��i��Z�dBu\�n���`��]H6�B���b.
i��%�6��o�n2�n��V1���6�T�+��}����	z�8Fl3nf��$�M��^�,���Qd�Z�4J��=tn� f0��c��V��k�eEٕڪCa�}��&j(�*V��tQ���5(;��T�&0�v�4�~��O� _�ؐ�Z����4.�~Fy�t��ۼ��-�^""�]5\���۩�xFX�% 5J'/_^"��#�M�r4!��3��¡-ɔb�p19�0f�ǃ��l?f�����b�7X�>n���}yGeL�o��?����\)}i~q53��@L3H�ӆ�<��Y�FSX��XR�U�ږ�s@Ri>�գ�����	U��V�*�r�X]��&�%c��=������ _,c���:G,gSG�b��-䟟]\�̞�;� T�u:/��n�[� ��a�%0�`�sС�fë�D9����(D,^���[�
��Q5�;ի�@G;˃�6D����F�0�z���:`�Ђ��?{ÄV�>B���_�7o�����<� x����X^I��#5\z�U����{ITR�ⴸM&Tt�A�fE��:�8ϊ���B�G��Lbc俌V��<ϸ��3��X����q����d9w� ���Q���1f������M��Ǻ���:D�@(dZ�����<�2�	�f��Թ5���!}��e����`�х��<`r����bL��^��?�,������s��I�����?\��-�?s���_����-�в�0-Uw��VK�;L�xv����ol B�V�m��ꑼGw$�m
��=ہ-���]��yF�WY�F�Ӎ�1*s�4� L�>RE�E�6Ѝ.�5(�(�߅���3�v��]G�d������B��Yu��H�?FwyV-�eeG�s)^��7c�]�A#�?=���-x"�3���-��>T��#�m����\��$�8ƹ�]炾�&N<��1FuŞ�ď�f�L?.j�D�c���|�3=��|[x�����?O,�.�^��=���х)`���ˢ�Ή�2s������<�/�����O���6��|��l�������ۂ��?�#�?���?��w���W��<wɿ�\fݧ�j� ���I�d��~���nV�/Qȡ9�;R�ĥ4��˃�T͊w�����!KZӰ���#��k���:䲏�v��hw�
�'�69�b|���(�Ԍޞ�:U�=1e�S?��1N`0�E�uA�6�;���XS�AB��h�qW!#{E�?"���Y�?����eL���X���$��B��<�dud|�͘{���p�G���XRq��^�W�k` ��[�pҜ�K��Jy7u���O��m1���y@uL�z��dGC��Z��DRC8�C�DB.�#8R��xT��N��JEة�bULU	�A���I�X���m]=CR8ґ����=>
��O0�v!���3G�⮸���;�����u�"#�ŭ쑈��	[�(��ٰ�+��W��N9[���+ʅ�mTl�:���Y���٪���f���5U?�;|`���n���mB�/*@7�Kƽ�1�v���뢵q��ʹw���n�4����Ć�?���Dot-~dW��)�6��g�7@��
����`��:���A��6����e�+� O1�[��%>�\��o^�,z�d��y���x:�go�4��9��������<`���ͥp��?��P�G�`!�����M�?HA�{�E��0�.�5n ���D.������)�`��\l�<pq�k��J w��X{� !��_yw�u+�=p�0���ͥ����؈��/��|����8�`+@߽ƽ��iR*Y�A�ٓyקߠ<�-7�ژ�������K!&������X����_�OV�-U-��t@�'B��/��Z'��<�����
���K$��?��¹X�_�������r�ô^��:�Y@Ɇ�s������^�=�>�A0�%�c��ώ|3�}��jq&G�y'�'��̌}���R
�§���W6�\��V��W�m��%�������)C}"e�k��d�{(C���B�u��_b�[;׽[s�k5�Wy�W��7q�nء<�61����Ș���l"[��3��+�f*c���2���ܰ��W��)c���f����Ź��7x�Mw�^�)JUP�?CіA��ی/h���Ur/~�Q,�Q���e*�g8�^{G�j�ƲD�rze��x��!Tj5.&գP���xi���e9㘨R��VW9r�zl��u�.�X�������M(�"���-G��2�;�aH��l��r5��M	U���l6�u�J	J�!t�I��-ewK��ή��Ȟ��[�&�4υ�d�q�<9.K��p���Jv�PO��ӻ�RF���9�9T��dn��m���AGn��~U��%K$.y���p��x�;����c�u��v.䒲���+բ��\��`fÑ3g�v+ߩU/q�3�p� 7��Y�\`r�ٳܱ��W$�s�?,�a��Z�����nRد
�n5W�uE�fY�k����̃�j��Қ��~wC q�b������zYլ����;��Jw�M�N'�֬�$Q;�gۭ���ۭev��ܪ��8����C}�8Ȟ3)������BIN���n�+���d���h�z������׉�]n`����ԡ��K�VrK�y�T�rD�N��;��=�>��1���y*U��r�d�ՉKy5������u��I
�{�\2��YyU*�r��I��P��@=��	]'v�d�[J�����O�(��d���B�P�N~�>=ea%��_s������ɰ
j��E:�tR)-��j��>�Q�E4���-�FM<�2����~)���:�T�����&*'������ʧ5�aR�4_=�wʥ��D:����l1�g�q��t��;��9��tu�b>=�5苋���Sx?��#?�6�ƶ��/����Ot�������R���������o�sޤ��S���w۹;�_t��/`>�?A�g�����O�Z���N\,gwѤ��}���e3�BC����f*��*����+n&3LW��r�Ԩ0���`5)�:��^��e���ʫ�v�X��}Y�{��T~��k��|JJ����+���p;�tR�ʦQ��Al��Ǌ���U^7�[<U�rf;y�\�t,����{�rEWN��\�UDGz`�-E�G��ьV�[�Ác������b�����߮�w���Ø��q����7��;��l*8�{���cQ}������zp��[�3󿿟vΦ,c�'X~���-��P���zG�}���}������C�s����)�e^�+</�#���`MQx.!ţ2��l���uI��u���yF�8�_YY�`��_�C�7��-�y�/�����_�b�/?}����f^,��!�7��B�
KϨ���a��j�K_.���q�jp�Jq���%?��)*e�a9j���gKK��Hp��?}��W�fy��'��@I����K_,��g�.Q��_<Dq?޳T��ҟ,=B���8��ԁ8/�/�i^
Q~�U��w�������G�ۇ����<=�]���^��HNۂ�������k &��������/��i�5��-S��]J�OD:�g��>�?�C�<3z�?��&%a/��t���L�A9&aE,�e��P����� 8)��S��.�{�:�B���DJ�V]mD$Z��pa��O`o��$�o#%���8I��UJ|F�z<^�eXg�D��$�E�V9�V��W�R,�%..�' Ts]����f�����s��H��/{b!�(��9��H�"�Y���-�u��w��z�l���teY`ϪѮo��t��'q�ė8qx8���sq'�$O���^*.R+qiA *U�[%�E�$���O�N23�I�v��tO���̉?_����w����~����2x';�����ED�T�M1<��+���,�e�*1�K�VX�,'��LK�8�e���ZF<J^��\ȝ�+e�U
U��"=�
�|��e-�y<ǑOU��c��?�{�}'�'�,�J��<�.G(�ϕ�I�����!���"�u�c�}��Ǡ�����qǝ������:s��U��ṕ~��c�p/�{ST�G���U���م���s'�-������"Qr��p������
����e7F�c$Y�۟x���{�2�����5~a�$=��.MZ.y֍~/�9� dq�.��
]e.�s��g��¬��JW+�"W#���5�<;���c�`Β\��Y��$駶���Q�A.�ƋNr��ղ��`zY�Ɠ�v�x�'{g`��H^��0-�n�+I0�i�'&�p5;��4R����#�S�Ti>�z���,��q�UU��tl�>^u|;7�,����
������)�����.᧫u��P����w<���\X���>���.8�kv�O>X}���<�ۋ�nVx}��,�&]�'�棳kh'�w��Nb9�_|qh��W��Z3|�'C�͈Y�3ZJ�v�iy�*�����-s�Hܩ�mAI�z\�����՟�.{1=��	�G�~
����V���{\��#X>�����>�w'�{���?�����W���?�����w����~������4�t����������̓^���j+|%ɷ](����8��a�a訉岸	����δ�l�M�	�2x����#K�VA ����a����g_�ׯ~�����m�7~�����/��}#�C�g%�OJ�w����ԏ�K��{[�h��^��o�������}�|��o������{���_�$7HR�e��I?N��ڀ�$�9�Bh�}<Hw5�$ys��[�������
SvNJ�[G�������:Z���4���1Ca���Kq���O4�7�b�)ds��+,�������t�&�d��h�GX� [��BǨ�U��LP���ՑF��,:�̣" Iq�M�3�d8�&���D�.KN!�"I�]��#�?r�|��J�tjܐ�KN���ܞ	!W�fl?lv�Oΐ����&J�CBҌ�j%��6/�4?lK��V��@f��2�7�sj葭d�r�e=R�)��(�Q��D#1k&I�H�`)�d��c��./�.E�n�M��Y0R�r ���u4��=�籲�{�T�ݶw.1ݩI�ʓ.K���Fk�X�T�S�Qm�W\p^��\-���x%�`�"m�S�q��ŏH�UiK�Zd�f����)P~@��(B<ݤ�X6�O_�bUQz��$~����`��XA윕�X
BN�݅L�'2,x��v���FV���y�"Hl�D�\t���:S�b�!E|�f�6�nAr�
���c6	��9����tNo^��aƲ�4*Rh]ͣ�8;�F������l^�"�Z��X�=գ�U\O"/
��M��2}^������8��,�j�8 )�9�M2V�� ��H��M�g>û�b8 ��1J�$�[���K��:͕�$��|8A[C�כn�U�����ۄb�dCYJ�9�N���Ȱ�~���Rn�~�W�E�<Kİ�h���>%a��9]?��|K+�1�}`>�"��J�:w`Վh���A�U�	=���`j2*K4k�N��e�������pf}�����bOP�f���Q�^\TIyЫm�9�3�
Ka�!�9E%|���#�(m?W	�&\�W2l�/tHx!,��ݬcAa�N�L��*�f�z_l�Qî"x�ҙ��&�˄��O��׷)�n[�ܶ��mp�2�U<�m�x���� �-�n[�ܶ��n��%��zxQ.�H��7����߅N��=��/��J�^��������l^���3����_���v���C8�����nr�S����N�����,��O��� �'N^m�K�s�{E%�c)��4F>�����x�}����u���khR�ה&���Ү\�	p��[-Ug���X�<(hT�2�gkR(V��b�7G�a[�p�L]�i�����4f����|�;�)j���i��z0�&׃��+d#Zmj�vXAs���^��w�t)��~E�"@�kx��}U�f?[��&ݑҩ��:q���N�i6\o�f^&��eBɵ�`  <��%�A�)�X�s
�~_�jB��6�\)㖘���+�q�b7��=���s��	G����Sf�6�_^��Z:Q�#�؁e3"��#aL��ˍ#��Wi	���z���]S��z��^��*V��*�R2CHCS�5�\=�{��	ͩ��Ə��\�b��R3�1�̌V�v�&���p����8��"]d	P+VӪ���_7_�TA.��|��e*MW�J�Sxf*���E�@�"[T�!�A/���u��j~�5f�7S�|>up�,�O<���N.�طH�y:����4o �?�~��Rk�a�o������o_	1���3�S�]���8j�4���e�r&�P�-�i+�<C�Ǌ�FέGI�Xg�v�h|�*��a�Ӧ�<	���
��h����P�ؗLP�|��h(�k=c�E������-�AFGΌ�wDg8!�.�5Q�� n@�k�"F�LP�@�Ǣ��t_��V�P�j���#��c�����\�AE��nԚ��d��H,ul�x���[��=���}Rc��I2��H�(�^�M���.AJO E�cl�qgNJ[̰EGt� �u�6�4�ZE��:ja[� ������Ht@��Ȝ�0F�L�����Y�k!�l�����m��@B���bM���+�ks�G��H �� K��� @�Q��hE���y����v��K�%ߺ2^b$�Yr/���5��r���f�$A���� `�q����ѿI������u ��T�NW���H��B:�Y�詜G#����.�E�1��Z~T��dLU;+���\E	�fqZmw'G0e>�#�"�ZSIP6�&+�m��q�d#n"����Ȓ2��n��t�|���2������M`ުكت�ffP��BЩ�%m4��v[e�����b��1<ɀ�v����9v�*��9���}��v�c��=�U��h�~�p�{x��ï]	��DX���F�5i�]�h�$�1x���w�?���q�q83μ6������K�Ey
�3��l~H�K�ѸQ����yc?�v��1#U�5�0������5,(���Ԙ)�@��XWk�lAԼ��2�C*�_�#�����G����@�d���] ��8�׫�ZG�2����V�{�FI�`��T7=D#^"]d�@���\:;F(���-'�^��2^aTiKa[/Ϗ�
�xM !�<j��bD�V	Pm��)r,(�#y0�F"훗�.e��Q��S_:x!u�e|-��zdo������OBNB��>�$����/�"���G��y�:8f<��A�#h�I�̆V���K�����OKt_��c�#�s+�F���O>���'���v�W<ʲiw��S?�,�A��X���[突�y���s��k<�����j��/_��<\��s�e��E�;����c=�q�s����O����ى?� ����L{�^� �GcQ{���Ob��	;����4GVZa��R���۪��"��>���A8 >��y^�	����M\�7��������]�-��lf�=n<�(� �~���o�M=���(���.�^������о��]г_��Z�]�=m����'����t������e�=����_P����������s���M�����.h����D����{��=������!��d��wA��;r_�7u������K�?Ùx���t���Nh�G�~y��(��>
�^�φ��o��f���]Ў�?��w�wJ{�������g����{��{�Gt�A7�������� v]�������%}#������e��w�c�/yu�>�C���Ϸ�w/�[������{����q�gL����`�������������+������T�����fܐ�P4£Ϩ��?u��(�طo,�y��2��ǧն9(Wg�$<���<�B���r	�S�*�@�Q�(�fr\���.��2�e��;�0�p��Q@��RC���lk�r��(���(|q<��#>7�����s}P�Na���?ꎏ��Ɛ��Rpq� �.�8?�+<���Χ����EM��M����x0�Eh"�FZ�k��&J���kAsr�f�ՠ�\-� -�Z��(�^�O���o�X��wA;����,�#k�������m���G��������3g����b���8�[����t���%��\�q=���X7�6l��g%��m������������5��&���y�g�c��+�^'u�N3�AQ;����7z����A�.��X�@��F�����YeN�9�;��@D�5��<�2X�N*8�p��̒�dC���N���;�&E�,
��+�݈�yx�DET@&_:U�PT�_�Zýu�ޚ��s�rU&��J�b�}�YG�M9�]n�h0*gkw�����Ը����?���Cc`�i���3px�S,������Fx{�O"0w������Gr��� ��'��`���X�Ŗ���G����������o����o������꿈��(g8>��(���"��.��<I��J���":f�$:��8���e�,����o��U�����F���a!�;�D�b�vH�ۜG�if~�C?�][���?�����F�g�.��	��޺���򰤫b����l�:s�x�I���ywն����E�
�k�͗{A��{���O�������S�� �-M������p�O#`��<俢����o\��G��4�b��?4B��1�Xє��h�7�A��	 ��!��ў�����_#4S�A�7������O����ߍЬ�?�����?���C�w#|��+�c�����U߿ؚ?�zk7�6e�����X�Շ�k��i�ۮ��Z�a�z:��k�|7�Z�֟�������]���~Ǽ�1�դ�I�e�^�S����r��%g���)�%�p׾Tû�([��0��e�Ga���f�>����Ѻ��y�u���N��k*�/�mߔ����ݕ�-�M�%Ժ]�v�lʞM�ֶ�#��;��e�Q�T>|H�,��T"�����̾�Oz�ݽ2i�*�>t�3+;F,��P�
^�D��3�D�X�����%co�$�7#�0������uϱd�PyA�t�}e_��p�*�P�!��������P�5 ��������A��F�?�8�C��?t�q�O�E���w��r���;��>9;�v��*iۖw�S^^w�@��mO�S�G�����&��bc(��X�Q��uÝ�ל��Ə��dkmzU�6tS�'9a���[��lד����.�˵����XY�c�n�:g}s�G;ɭD�M���n�jÍ������-\n�+��2���1֗�n��W�������%�ˎ<���{����!���p��������p�8�M�?� �����?���?���v����?�����S�����'�&�����#��4�b���o���߽�M=�~�c5�������b��_ �o�������G����_�����A4��?�����_#�������������������B�Y��@&����߷������?����A����}�X�����������������Y����[�������7f�E֙M��nm���@��������M����{�h�]�k������i�Y/kO���Ɖ}?e��6;�����ː��Ѡ�}>�������P9~26gw�]��ˀ�ꢲ�j��)��$+�B���������_U?8�/������Y6;�N|�<[�C�������1X��)KI��)\���7n���xZ~�����3�,�YT=�Ri|�{�/�i�隴Z�����šPm�?'\r����aq�������^�-}"�SΚv��,�F�<m�����E�G�8�����	���Zw��?"������g^���o\�?c�\�%2�D)f2�!iĥ� ���1Ee$+2�@�Ȳi,J4�r�$Q��P�������������������?�����������_��]��fE'������Z^�8rXpƶC�7�$���ک�)tŨ5�-֓��\��#˶�9VV��g��ަB�n����b�����	/tg�醜{Si	�z�z�W��9q҅��aM�6��:e��pOo
��8<�!�M=���F?�������Ё��C�2�?� ����C�2���A�?�����������P�!�� �1���w����C�20�0�� �����?�����!��?�� ���������@6�����18�����������F����?���Y|��mj?�B#_p���7v7��L�?��ᛉ��8?�!�/��nM^F7�4���,��h:��]?�&��٭.D�&>v©����m��Ƿ���R�K9�H�x�^�vXw�_�i55}vN���"ތʄ�M[�{���*3e�Se�R�Arn<6��:��SHKG����:���*����r7̉j�eM=����RF�8]�y]N���lY�Yw��-/�=��h�غ�����v(�{���*\�dfc������V�͙�FKS�ku~�ImrB<�"?��?t6}`Y��x�J�-�{��)���}�	tLY��:T��w)��U�w�|���#�����ד"�c�v�b�;��'�n��h�w��M%�SWI�k����<����8tO����t�T�}ݥg��j�\K�>.I��W�)��֤$��s\�y�.E�\9YR��~��gg�F
���b�,�?��@���?��}�8�?����H�Ny�J�,�c��r&�x)�"�b�$�Y�dҜ�%�&3��Y���<ɓ�J�L�������t������l�D�9u}� ���$6C�H#2Ldz���n��O�֘��oity��Y[U�~RF��V��.���K�i0�;��O�D*�Vr>��(K��:��m��f���}�u��%�|/o��O�-��'�?����k�?����6����?.��}\i��������&�A�!�M���o��/�C )������򿐁X�!�1�������{���?���o>���
!��є����/���_����\�{����&�+�(��@E2�����ߧ�0������o{xK�y$νӑf�C-ȵ���Z�lV3'/<�C"�g�ji{Y8S���U���S�6��t]v�} ݖ�MjnT��5k������<��io�� �jk��}�Cɭ����fpI��c��?��*u�ǉX�)���~?�7�Tew��X�LW�Rs��n����5Q#�Qd���޹�t�c��4R���L�Q����3�����m��_�@\�A�b��������/d`��`������������[�߾�-�k�0��t�M�2�;�,�$���=�_O����6������Rw�4PH�,���tܫIUB<�y����iV�{T:�!L��Ӌi�u�����Xך��!m�c�_5Ϸ��i"�Kѧ�;��V��k���~����`VPSٿ��%�^�j�H�s�WOVM^*t���F�]�-��n��e�z�2Ъ��0]���ڎO��<+��j�˔����ȮWjje/�KlM���V0���m��wi`Q�A�2���������B�!�����������Y�����&���>�S��>��3͗�1�R�:�C�7���/�����������:)���,>�U�ߝ�T�V����վt�	Kmv�|���l��9�=�<&\*s��T�9ūǽ�{������e�Zr5)��i]�N����'����������ǹ�/������Y6;�N<�K��Vfǐ��ȳ���e��n��L<S	k�.�b�m�LN�>�u�����#�s���N���݉��E�ͥ�E��2;�=����]Όr6=��2/iݟq���Y���to��}�:���[���Kv�RK�]�9U����.��� ���?��B���]������\�_���SFbH��*SA�r��#�d$2#3��bR���K4Q<�=r�H:������������_��+���p�Du�a�Y�`pu|o\J�y���nlN��ր���e�wwjMf
#�����{=�5����t"� ���:ݥ�չ��q0��l'ɗ@��B�^����]�����d$���f�$�}/8<�)�~���w#���'�;|i�����#y�M����S0����?��bKS�������	`��a��a��7��X�M9��3)ΥLHEI��4礔���hNs�MHNL��JH���c2M�Ϡ��f���_��)��i�_���f�M�\��J����F̨�Џ��d[�<���[d{s��}>���5�N�~;l�Vk��c��=�抖@��N2�E��Ӎ�5��s�4C����Xf]M����luuVT��z��ޅ������b��?$�5�����*a [���?��g���F�B�y�EE3�1߸���Z�i����h���b���)����o��m����o����o������B�����+���w�������hV��������7ˁ�o����o����o���0���f�?��������A���t4�������[���������?���������7E�>��4q���s��������4�����᱀����O1��/��7b�������G������o|�VQД������ ����������CP���`Ā�������*0�0�� �����?�����a���?�������B���?d`��������o��!��!���q������Uv���C����w����3ԋ�������s�$2i��Y�qt$�R,f�\�Id�dL�2	�$�@&� qq�p$�	�������z����78�?�S��/��o�/����{w��/C?��'�5�k+͊N�ѣ7`Ys)��+?6���ػ�65�-{ϯH?���y�/��P@A��Y@EE���5�T�'U�I��ջ.�$�TJ-k�{�7���IنCWǋ�-���$�5)V^���Y�g�9sTO�?s�{	[���8����V�B�L����HFe�\8�K[�U�}�S����3��E�t�5]/��O-�6��I���w]���������q���C������N�?��h-�?��h������ ��5t��A�O�B���i`�����0��?��kA��������������:�������?7���?��������Z� ��e ����_'���������9�F�?ARw�Oa��7�w�?.��ȓ���K�l��^�� ���?L3������Jk���A��4���ؓN�.I�����9}3�.�6�l�N1y�;���[��"qN;[^_f��K�ng�?��WԵъU�s~���u9�rLÕe�ك9�D_Q��rVd�6u(��&�
͙	� �$u�h��瓚��z��ٕ���Yfg���`��߿���:��@�GkhY���������]�������~ا�>�1���T��QD1X��$������x.��w]�p��� "�.� ��������w� 󜗝��w����X&�8���ἳlFU:��2M���%�C�N����cj�<�0�*Ѷ�����HFl;[���]�Ѹ��]�l�׋����g��K��瘳hz�@��G�o~��}��������@�5�?�����%���������$F���	t��a}��@�O#h���n�}��}*�ӑ�$���ݠa>��<���>C	�I�O AH#���C`�� �x����`�C#���O�N%,���a"��3rꎉK��¶j7$���G]�����nV[f�;0XƦK\[�XR�h&��F��T�#L�z�Ǚ�+������R������	��/�����Gх�?J�����߆���v��������O48�m���­���:�5�U���Gz�H0ed�������������_<�]����b��X%��?[��������ۖ/�Wz�޶|Ao����o��em�p�ז5��I5k��!.�_:�F��.;�����M?A�"�r,��;���Pc�G�X�g]����ư5Ǎj�����Y����6�i��U�B�t���;q�foMav�4���(�b����(��%<S5j��{�)]�y�xe(��f�-_A�O|���L&��L�fфL%��.>���z�K�c��G�m(,^sk�V��|K���p�-�z?��(Q=yB�v�zq�z��4�o���4���&�	�O=�� ��4��!�����m�?��n���0p"�4��?<����h��5�������&���W��)3�y$`�
+���������?��k�}������p���<��Ne¹�qB�3:�iq���Bh�xʗ���i��%R�T؛zɔ=(�ɡ�-fd1�X[�x�X���н	��v���|��Ο���(<�x���Q����)�*�Y���Z��v4-*��ЩZ×�b����R��6�=Z�Sk��d����a����tЄ��"j�H�R��C<�]a�-�'�T�pL!�UW/]O��s6a��#�����ȗ4���p��>%F�+������g8�y]��7������F�����v��n�����=4���>F�	���%�����!���&���缛��'����>؋＾xu�e����j�̵�=���L۽:�Z�g����S��<���R�j�_n^�]Րc���-�G�@��d	>��n2ԓ�\�X����Ӿ1]{��?�s�T��;̮�k�0x\�۬��>�����Mu=�P�O͔{m�xͶ)�}�<��ϑ>:2�8[��A�Qݙ��� U�$�e�D��
Ǽd[�\�������C_q|5�~��<8��x�
(�����o�,Y�3JڸLR�l"����v��SH\�~�oT.U<U���Z��R��M��l��C(���Z�@���.��h��	�W�1���?̶��A`�:��el����~+�ď����k�������zXNH�@��f�H�!�1�rϤ�0��:���잕R�!gqS.W�j1"B7�	�kޗ��jh���2�(?ٹz���>�]u���$�Z���9^�L����&����u���Ľ��0bnpӾ{F�y���b�8�Ús��<�/cN������B:���zJ�xR8�=���)zef��CA�K1�򂓏��]�2�@�5��@�w� ��`������_���?`��4��@�{��C��_�&�^��Oo�����A�f����bɜ�x݊�?Y�޶rC[]����7?Sf����
�6\��=�`l�:��p�Y�?�iK�Ǟ~�|��6:)��^d��'3G(�����8c�\�7��p,���O���D�fVexҕ�]���G�B���/u`��,c�������z�e�Ե�I:7�I,g�����̢�U�L�3��%�������B�'��~���$��������w���`���nm�?����.��O4���O ����?uB������j���.�?0���������?>R�cFoq<�c�T��'9t9Ә������5��Ǘ��o�������S �"��mW�	gɓ�[J�,��9�6�����Xm���r=�њE�DQJ3Yc��ݝ�}w�7������`jy�u�2��c8R����%���A�sB�7ʊE��?Ηh� ��?qc��O�RB���昵M1j��N~�����w �E��U��/-����� ��� ��[�u��1��%4����5t����O{ �P��P�i��?��J������P޾d���_������?� ��:���]�'�`���@3����:������!��i��M�-�;�����[��n�'��5��?(
�������W���F ����������kR���p� ���[�u���������`����������������M�?0� ����_'���q��M�}��{�4�N����ǀ�o��������7��L��2#1�G��"�����������ľd�qΑН�q^�}�k��E�p�f���N`Z츱�3��e/*FiZ��A�T5���_2e
frhy�Y�7�VD3#�y�-to�b��r�uN�\`����X���e��'��'6eY�/_��2����iQ�?�N��\��L��H��}�a��"�ZcM%�}��ޯ9�YE�������x�K=��8[�7N<��t�B:ܫ�^��|9.�l�R3F$y����/iK�2#}J�$V��q{�σ����C'�� ���6���_��*߇�����?���������ύ�u�#&d� c\��0��(7�i��S0h��P7�����(�#���WkH�!�(�wq���?�c�)���)���I�����?�G���|�������W+��(y���ڽ�hZ<I`��Hu	7+���ر���v�W�2mR&;#sW:{+_Y��G���e +�q�nW������x��A���/s���Ed��l;?��*���Y�N�#E�`Pf$�Y�X�j��T�/x�Ѕ�?J��?p�o��_. eގ����W����:��4u�� ��4��/���@u
�������`��A��B�Z�����?q���?BW�t������g�?QP�i�����O���n���_P�k��?�:��������?��@ �7�N�?������A����@���O ������� �����@T� ��s�N�?q���?5�����G�I@���r>��������V������R*�Jp����L�ؿ��Ŀ��׵����ԣ�����<˛�� ��f{��"����B�?��Z̊��9���t&3�8��GCJ��E�r9/�9�H��c�t�Πʒf�d)!�]�iy�����S�3,�N�BM����ɲ�n��c5����֕ �j�cMS�K���j�W_b�z���4�+WG>y��)�k��n?Y|�#�Gbg��Wج���R8ޗQVn
���4���N�;�*�l�ʩq�
v�$��z,4��tc���_��ĕ�n�+�Q�	<���	��Р��%���@T� ��s�.�?�>��󿍠�2.��Gh�A#)���~DR�G��G�4�tA��}�����Gq�	B, �@�*������� ~g�"���lH��'�K� Y�)��$?#vTin�*��RI[��{���go��EJ)��"�s����f;/�A鎐��t1���ax���`�j۽���j+8�
��j�j�S���S���Q|����T��G�*W?����Gi��?���_3���^��=�\A�?������o�Dɾ����}���/�}�������+�o�mP��a������H{���{�XǱ�vf��w���.�3������^f;��֯���W�b'��8���V�HP�UZ
m����-���-�G���
u �/~T$�����ܛ������}��w�����|�wNڱQG����P15k���]�����y�VL�b�GX�(}=�~�$��=�"���o����N�ƍ�h�U�+X4y9������@sծ>��W�mG�ƹ3��b�8��؋�֢���6�;��g�>�隩cK�����BBB4�Q��{�X�Ϗ݉ǎc9f����V�t����c=�O=w8�e	�/P����{b�c*�x�W{�0��3���]���^>	���t�;�65��,_WGq��G�p����U�{U���*Q�j��Zx8��9�Q�r���b�n\���u�}�;t���>܉y�>L�9Z�(�`L]���;a��tM�n���l?|��F������ڝ�4�Gѵ����5:���ʎ�v��wڽp̑,�	zwN0~��x�t�b����I�a4��H
F�Q�O��O ɍ�/ �q��[�/n}��?��ڹ�b�_�q]E5CCQUO%Ԍ�F����4I+XRE����SpR5��j��%T\O��c8���Q��E����4?�������g��/��Ͽ��q��yppS�}\&<�g����]O�b��2=��^|�M.9B�i����B�*,��t�+��>w���ֹC����6���B�
=�u�߯�랪�P��гЕ��Ҫ ��uE;T�W��^g0t��&��������>�ɷο�����~G�6���Ε�x��]���?
�P��wL��}�_*���c�M��#��R�O �l�.�t�����}��[�J�������7�|���ٱ?�ԾFAߓ�w%�f�[箞u�߿��#���k9���K�lj�1T����L�`CIJJ�ө$���6�D),�����hO�)I��%����K��귕��ܟ|�w�_��?�.�������Q��A�>y\>z��'Hѿހ�q�@ƿrm��σ��o=�����T~�����B��cq��zB
	z�(�kZ�v��8�J?�8xN$�qp&������H����' ��Z�D5(Ӆ'Ζ�zTf/ʂU�M������瘠(KsF�BzE�E�[C��RoM�>�5E�Α��#O���dǠ��f�:j+��ݞ3-�T��;\-|v�У��+b����H�o�_�/Yh2Ah�y�/�%ͬ�<:˛����2��\51c�~����Ipߞ�Gx]����P)�U�`9�b=�؊H:'l�'=�h-���al�F�|tM�#���I����;Gu��5��(���2e�4 �n�hM�\3���X��ލ�|�{�Co@�/��C�R�j"m0@��AE����TV���"�gJɂ/�]tq�*P<�h���!�uJo��f`��p���<��҄�k�C�=��"ۑT��R���r�<&A̜�9_2BԜ�S��&V<���v�����e6!r�޶��$��V]��W�g�"�h�j�R+�[��C��A$J��P�GT��R���%M{�����l���n`r~|�Kf;��#�{Y �([���M ���hFLA����-*$�d���|\�a�U�ל8	��('(����q����_hr�BE>��w�88n�$8F�
�8��Β�L�A�p|���ɖG���h�r�t����ш��'�<^��ݩ��OT��I�k�Kuʭ��B�@lK��xP�Ż�,�cb����""�J�Y�̶�%l�Y�gi��U�|M���lT����N���15o+�3�h��U��g�z��$��r���f��Gc���d��csS���8�Ʉ���ǘ��!�S�%?L4֘&yl����^����f$��q.�)���:�`���hH� �%�d&�l%g�a�_k�Aݨ X�ܙ��G惘e絇�k֎�����u� װ�Dv�Ux�B���A�����΁��Ev�8�.�Ǒ%�͟��$�w��֓�8_r�����6!��iyl�h"�z=.�l�,�Z/gACȳ�I�=[��]�A�����!�:R��5��&�N��mI򒭊0�(��r�ԟ`��<6p4��Q���z"�k!�r�`]�zU�����$��wX����JW��}w���~"O�63`]vN�j���Y��&�sl����B����˨���HP��ת^">)&G=�M�3S;;�]�qe�Г�$7O���xR�t1��b�{Kѝ��R����W�נ-�b�y~�����uoz�j��7��?����ڂ:Z!�dM|��쯔�{�`M��g��~e9y�
��+�]9�|�䝟��W��|Q��b0!���%�"�:~��{1y/�e�~�6y��2y?�tKJ�M�A& gg�]K�f�ۭ�ܦ���H��Ġ^��MWy�VA:�!���6�{�8�SR��4� ���X�1r��x�{1y's�,U���n4{�u-׃�Ŗ�D=$msjd��_Nf��'��p��D�U��-| ��&�n_n�,���V��ݡؑ��T�f��m�욍��auF�
�${���M�C�\��(�q��=fK�f~���z���t�SV�~_L�C�qib�!}@M쩩�4���\�L7��I�%�a0���֤V+H���+c�t��	��Z����D��+�^V42sK������K�黎廰L��㎃5?	;���z3#Y��s\c�6��0��M,�rjTŽ��r�J����H��Ac�y�,>�M��a�@�rYo��ޔw%Mt�B�"�`��"��r�j�E�̿k&yT����`b���9j�u_�-ש�=K�A�COo]����r���F��n��"&��.��[ �}������ͥ�~�&�7���<T���������'6�O��/��C�%jd�y������AP
��j{ r�<����.�&F��Ngw���$X�����'�U٥��8R(���x�[�穩�E5]Ϲ�6?���Q�_��A��.���T6��	�.+7�r�oB�Jw<�)����x>�;�>�9��d�$\p�L�=�I��7LZ������Ն�Ȗ{�VʲE9`�R�)w\�[U�	gu��,�.?n��bs8tYE�i=�����+(j7i���n�L��s��K�M�c���9~j�o����7ު�0o�&z���=z�����ͯ^l~���W/Nue&�����n���׼��@O�{����?��Y�@��f�����=�&�����.v$B[��ۿ�D9���}q���U�"x�w{��A��%R�����s��-p���o���ߏ�u��G���;A?=>�����W��s@�kG���q��s�H6��>9��F^��%��]Y�Y�2����V����v�c9&�3��Ӈ���{��o�Y�M+#e��0��E�qH�����
W���iC��uz��Oۻ�؉q¯���X�m`��6��l`��6��jˊq � 