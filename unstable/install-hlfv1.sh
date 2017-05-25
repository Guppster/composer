(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

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

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

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

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Bk'Y �][s���g~�u^��'�~���:�MQAAD�ԩwo����j��e2���=��/��tM�^�[���u�}����xLC�˧ )@����$��x�/(��(E��}AP#�/5�s���lm��ڗujo����^+���}$����n����^O�e�!#�r�S4�W�/�����+�b�c�ѕ�����|�Nsp��Q� +������W������O�����_����g�8�_�˟�i�������t�eؙ.�t���)�����ca�GcAQ����:�ԞG�����{������]��]�<�l�%l��i��X�$l�sY��|�t|ԧ)��\��(�EQ�'����^�������"^��8�>��x�9�K)��p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��+��K��ww�o�_�ۋ�K�O�?/��(����J�G�������:��x����=��R��R����nȒ�f����2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe��7�@�9��aRf�[7"��
��ʸ��0i#��=də=Rg�A���?<Qd�a.�9�ĝh��&�or���s#w�p�W%W�ǃ�(f<�8'������Ď��L�4��x :t�rh�su�4���6�P�I308���`eS��F���c�[q ~�,]̅��/��O����xk��X��?�&��B�7�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��r��sM<�<��ީ������B���J�ϕ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q�u�!�%�H�X4�9����l���܆g�����r�K�?��o����?�W�_
>H���?�^��)�c(AU�_^�qV�����#ü�ީ��.Yo	$��-����9ǉP�1�%�
��Q�N����٩pP�8*�*Hvq��~�Wf��9E�w���7��0EWrH<�0��'�5�%��;�b��V.�SYS�Q���lM�HM\L�ޕC�f�ߛe�.�i���ռ��"ľ�@h�}�].?���gᲭN�ȅ�D�=�5an[8�ȑ�[���9k@@H\^��!��
 y;?]d��Z.� ����>kr���r�Mwp�x/��-��))�D"�a�t�zr�a�:D��K}0�m�`B2���q���D���ϛX��X��Q���o�m������}?��Z2��h�Y�!���:��x��_�������H���("���_��#T1\*�/U�_��U�����`�ߜx9�!U��%�f�O����*�����u�'}�p�/�l�8:N�l��0M���H@�.���Ca��(����U�?ʐ�+�ߏ��梊�J��?|�'��&�<i�'�ˬ�YB�+"�8�0��(�������ll��m3b2n�I���-�/�eK֓�9�6��s�i��nG�sln���_n�ۭ �Q���R��a���^���b�Y�������������/��_5�W��U������S��+$�G�?$����J������ߛ9	�G(L���.@^����`���W�%��7kpl�L̇0�н�4��ށ
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��BA�:ܠ�ɪc��,�=Ѻ�i[<2.g�cFґ����9��A�6h�p*4�	Cr��}El	`�8�v�vS4���MV&�����-�3�q�|�0�ٓA�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_������U�_>D����S�)���*����?�x��w�wov9��Z�)�D��������1�+�/�W�_������C�J=���	�C��W.���I/�~�a04�|�!��� <g]�\E�@I�E�E��Y�fI���,��e����?�&���+���L���j�*�7�[c�`��Ǟ#���~����� ���P�;aw괒RCCrG�v��|�a�' �؍r��*mw;p{G��=1@<Z���&#���9���n7���ލ�����~����(MT������~���c�����.����eF�r��]�)x����}��q�\�4������G����˿xMW�K��0����d����j��|���4B�?��9�m�.cS,���x.����a�G#�n�8K0A��6˰>ZM��2�������>��t����0Qx1�v�z���`�]��c��F����_��Yh����8��u��RTO�È�<j̄�]��kF�A��!�Sn;�"l�z&⚠:����l���y7>R�_Z���������JO�?
�+��|��?(�4[�B�(C����q����'����R�Z�W����������]���X��a����ǳ���Y@�~�g�ݏ��{R����]R�z�F��=t�����nX�����6�~�>�Ѓ��6��2q�p��N�}1/�.���F��"1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8��.�uN_;-s.���k ��ݚ�r�kg�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey��ևA�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`i�_Z���+����?�W��߄����Va�o�2�����l�'������m�?���?�m�a��o��N2;M�p�g�?�_�q�(�g���@y@wA޺d�d����a�5`�5M|��?�O���l��ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ��~��!޾��݇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/mq����d��W
~��|��Q��)	������?e��=���������G5�_��W��������v�����0����rp��/��.��B�*��T�_���.���?�|�����Rp9�a�4��$J1E����>���8�N�8��(��S��庘�0^��[������h����J����2%[N��95c����ͩ����-y#��E������Ds:n+� �Jx����^�����ط�ܱ
'Jj�9��uG� ?��]K'��@9���C�ި��Q��мZ��^x�;��B��$���}���{�\��B۟��Bo*�/[?�
+����e~���~���\9j�id����d������B�I��k�1�E\���5re/��}����N�x����"��UM�.�7<�iv��]��W�:��OOL�t�}�ƿh�$����t������ֲI�ʭ�����x׵����q�"�.�ګw~�����������|��y�+�vZ`���7���]y�.�ƋM�?�k��]ݾ��)n�{���K?�Y�Q1*\���bPQ��W�9O+ߕ�2�n�]4��� �~�UQ����7D�.��ߐ��ϋ��Ǿ�WD���e�ZUI��`�;j���y�av}�(�΢��/7�˃����·��śWk���Q��9l/^���o���:b��"{�a�5o�� ��w[/�������Z��_�N�~z5��5x���ߟ_ʾ��?��c��_m�\T{X����q:�.�o�~��q���8��8K]8��'�0Y?P�GR��jO>���D����8���}7@U���?���Y����?6��Wlñ�E��������w�F���Y��{�@�Uő�m�n�ǧM���וU��f9�}�axgkxk�p�Y�gO�:{���o�jc\��t{����Ko��Xnz�z����8N�Rǉ���$�w�Tw=�c'qb���
������X��hA��$�~��?��]�Jh�PW-�E+?�c'�$�d&3�ޖb_�c������ׯ�s��2�zM��y��`��l�:���r��JH�<D
��T:E'b2_f=�Ic�\.����ƒQZۺz�@u�$�b�3�}ͦȤ�u�&ZL�2�n�`�@��bZ��I�<��-�9!�CL�f�NWW]uUQ��!v��_�51\��@Pk�A.�c%2�aع@���:bׄoX"�2r��P7�6�MU�����N���%���)�3���':m!_JgZ�{�9�jb��)�W�w�8g6��1�`毙WnN��zhN#��[T)�7���Ѷ�������)�PZ����UFM��N͸=t�q�5ESl=�bol4]�!�[4]h�p��N�&r�ԁӳ�i`	N��8��"8�]��i��N������u;�SS�����NmUo?Jx����ZהF�5w[�='�t����4�I��8Q��]O؝��}�r�a+;�`�tFW�a���������-݁�̾��e��DM4���E����.s�VWE��Pp�s[�a��+9s�1S
�a[����\nB���e�*�)��7���� ��Yjt�jK\Z������t��Ѿ^H���ڒ�	n�0��~�^��G�=�Th��IZ��G�KR�:Sf:.K���a�̘�{[����Ń�ht��\���J��}��k��+�kUV��v�za��u�9�uwZ�t��j@?�}Z�C�z�(�{}���8�Oޠ���u��V������?��pk�?��ϫ�_$�Ӡ�ua���O�������V�O�cuo����C��`!>�c�~<Xq/���E<��}��z�G"P�|B|.��>q�����\}{�������=�z����O������ֳ��A�x����|�A��wO�����o�0.�����7��7���_C�p�ܵ��_�x�1,���g�����]i��H7�y����r9��B������� eN⵮I�ךdi��"�`d��o�1D�+�=Po�[*�A�Qo"U�ʽ�n	�S���
�RL��ώ9����%�9���B�d�a�N�A3�����f���s��[�%+&��"9��نn�J���|��? è�Z����!�0����dG�Ā��a��	������.K�\6?j��n�,y�R���|q�H�V�(�50�f�)!�}#���*�������#b��g􌆦��f%T�G�C�|�a�:LX�	�	���1�9a�s�zB��7��D�����R {O͍�u�PJ��lC�Ǽd0�:�I�C���ߥB�U��Tѡ���Am��x�H�R7�i$�@{
N˹(�oy�ŔB��N��47�qY,[͠\�T���D�'��%d="� ;V���d/���#|�+��i��W5��/7��d�f�6O4?و�@�qZV��ZC�7��l;n���d�RKJ<Ǒ�f$$�ر�h���='eY�낲�ys������j%8tF�QЛj	h�+�%�XPx9�	�x��Q�}�k�b�(g:r�	�����k�@�)T�Q����)�)l�(+L���2u��,��d��d������Ze��>2(�l`LSF_L����
A��^,��}�d��I�R�Ѹ^.��>�aa�I�A����A���)y(�5��^[eI�R��
e�,��%�'"�`�^M(�4��@J1��ScoZꍍva�D�Ѡ��YDH��Z�����q�Z�-� �F����S@MyO�,Q9�P����PUi��x����aK�rDxAv��p�]�?�`��CV���FyvP6ZOI>�e�%���-E?P��օ.��R�7�c���Wc�(���˽w��������m3�m�i�7�.鍮�Ȼ�k[w";�r	���u������v"��!7�}�\�m��|��;�ʊ|�TE���9�w����.r?r7�����[�p��E�sPFU�y ��G
��uIE�\�y<@Mb
Y���뫆�l�u/���g�G��l#��ECUT[��j�k�E�-��-���3�Ʈ>��n��ȕ�7!`�{��-s�6)�E^iԬ�#oE���؏c.?��l��y��S\�����2�i�/&>�9bV�H?�Sd�AVu�㙁��� ���H�����9�����!�y��6��m���s^
����_
�;q�,<��d;4�5s�>Q
S�b'�������}�A[)����\t0��֢��b�a_l��`�Ȃ�3G�u��Y���i�Wk� �yp�{X0�����},C��1����eگ���F�x%�ǹP4V�3R����$�x��a�9т_J��~���U�x:��&�6�J�Y�k,�T92��Z�̀�b���#d,,e�sr�4f�C��5d���P�h"�PB���������{��Ԙ`�F��Z�GЁ�X,��Z2����U�����<�f������pd��^H2������`zá��C�����h^mp\j�A6!����1�8�8���zI� o�N�[��˦?4uL�S�|�S`�g�(�|p.���e;���;�'zX���?1;Ƿ�������xXN$�I�t��G�V%ZKc��i.�$���XR ��78r8X,��h-*7Il!�"��8kPdV+0	��Wkβ���ab���`1��m-E�� )G�2
����C�;��E���3r1^�0��U�O����x}=RU���h4��l%�`LB��K�����p�`�a,�*���(���!�|�-v����+`qO���b����K;� C���Ƥ S��J�F�E5\��c4ϥ0f��Q"lmO-���qCN�)$Z� |��E�ڬb�^?Mz�
-�����c�q��ǩ��b�o#��{j�l!����Br��vn���]���qސ)��{B��[�­���9��iD���t�0D��}��>�-~lO3%I�M���l�K�8���; �Q�<�G5���E�r����6�����{��=�~���g_��s�����������s?����ך����ʉ��\Ɖ�O�t�����ޖ�w\_��}�)����.�GF��d�'?������Of�F��E�ߓ�KI��$���4�~�W�rW4&Ӊ5d�����|߻��h�?������Ǒ_|�_?��G~À��W��9j����ˋ��_:�N���P;��Cp���W���W\' ��j�C�t������l�j�����z���Mh�Ap�2C�\���m�����@=�x�9Cg}�������#/�Q^@����9<�S��)��8���k�38G����Af�����٬�93N�ՙ3�Lp�8sf�p��6̙9�|�3L��3sn�w���Mi��.y�ɜ��/�;h�1����������@`I  