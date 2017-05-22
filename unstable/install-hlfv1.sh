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
� �T#Y �][s���g~�u^��'�~���:�MQAAD�ԩwo����j��e2���=��/��tM�^�[���u�}����xLC�˧ )@����$��x�/(��E�$�AP#�/5�s���lm��ڗujo����^+���}$����n����^O�e�!#�r�S4AU�/�����+�b�c�c������|�Nsp��Q�(��_.����^q��:.�?�V�_~I�s����e \.���J�e����Ӊ�ag���=���N�O�����EI���:�ԞG�����{������]��]�<�l�%l��a��X�$l�sY��|�t|ԧ)��\��(�-��'����^�������"^��8�>��x�9�K)��p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��+��K��ww�o�_�ۋ�K�O�?/��(����J�G�������:��x����ɞ'��@*�_
�^�Y���l�Z~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��F �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���x�ŌG�!��z�?�[��Q��܂���@��W~�N��"r����;i�2�̢l�5�H�X��`a�}� ď�������E�I>�{o-�+����g��x�P����P�ȀS}U���ÛC����F�v#a����+6F�L��~�A�ڀv�,g%�U.܎Pޕ��e��(nugJ7s-j6:p����{B.rp��G�'3�;�A�_�� \�_�[ix⹲� ����"ב.�ˢ�N�rІobd��<�� �-��hӁ����H���Jy�2��E��#�ס��L�Il�@�0�"�l�Qs^?���߰����!���-���&���>d�b��F<g�x��r]�a���l��ݚY~��g�����G��K������>����>�-B�K�k�/�
�w�;�ׁzd�7�;u��%�-��=q��%��|�!G�8*�#F��P�1��	���#;� � GS�.����̽?�H�?�������J�gF�D���d�{'ZL��%p*k�9jXC"ԗ������ۻr��,�{��c��"�s1����V���( ͽ���K���2�,\�թ� �����&́�m���9�zKӔ3#gh�ˋ"�?�|^ o秋�8^���X{x�gB��Z���C]��;����6%�|�H�9��A�A�9lQ��Qt�f��LH��5>�8�hQ�y��k�_8
r���M��X����sS��gr]K���m3�>�P�0Y����O�K�ߵ������IV���C������{��.�D��%���������\����s/��x[��%�f�O����*�����u�'}�p�/�l�8:N�l��0M���H@�.���Ca��(����U�?ʐ�+�ߏ�(���2pA�����IA+G�	�2�x��犈 4.�7�|x1�g-[�m[����r�45~��Ko�R��d3D��/9��g�A�ۑ���s���W����v+�j� �n���iX���������S������������/��_5�W��U������S�)� �?:��?U�Wޖ�3����̡�H�>BaJo�vZ��?������r��,a��Y�c�gb>4����m����T8.Wy �Ȥ���L꽩4��s�m��{�;�9TD:FwE�z�ӹ��6֛ɼa�]c~��@�
����NV�;�g���5�H��q93�����@~���-�A�X$�S�qN�s ���(bK Ӑ���s'������m�2	\X�7h�y��磅iϞ�P���I`*����;����C���b��v�in��:K{��,�;�!/7;��
�(!�D��|$s�"yY��	���@N�b�Ak����S���������2�!��������T��W����������� ���Q���\"�Wh�E\�������KA���W��������R�}-� U�_���=�&��Q��Ѐ�	�`h׷4�0�u=7pqaX%a	�gQ�%Iʮ��~?�!������*��\���2aW�W���X�plNl����{���6[�A�z�^��C	��yܩ�JJ�E�Il/��j����hc7�1c���������<D i�l0h�C���<�甒S�ݬ��{7��z~��[�_��4Q����7����w��������\(��ח���t�����p������r��8NT�/)����^,Őj�o)��0}���������?K#t������6�26�R��Q��,��x4B��x���o���DQi(C������q��j���q��O���>H-�j7���X&��\=V�k��������Հ&\xٮ��sX]W|.E�T�;��ͣ�L8�u>ʼf$���-�?����!�V�g"�	���� ����֫��w�#����������J�����$���������'����K��*��2��������o���(�����_�}��΁X�qе�x�%,�!?��y<����%�������a�'Ui��%U��n�/���CwA�y��hh�n#���=hZ�a��-
'���N����R�NkĠ�/�վml�8O`���L�z��"<c8x&'8�d�ub�ysD�������⢹���l�LT0�:����=�m�(����1��"1`[����"�0�BK<��9߭�+�FqFk�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\����`}t�@�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4��������������q���K�o��Sx���M���Ai��(C������ǔ���/o[�ѿ_�1nۯ�x7w��i*�;<[�}���{G��<s��ʣ� �[��u �'�@���-��) ��i⓰��1~��`C���Nu7%�},mQI�����z�6�}�VzjJ���[3�c�҄�!��fL�9M���Tnx@A����㤯&������n��� ��>t�����d��As�j$Z���ټK��i�^)�y�HVs��{�)��a���3[���Z����A{��h؄�=����O�y��S|��i;��������R�[�����j�OI���&��9(C���?~�g��>���j��������h�ߵ���?�a��?�����ww1�cTQ���2P��������[������O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0���B������/$]������ �eJ���-sjư���S�m�m+[,�Fi�5yq��1��t�V�֕�FwGѽdMq=�o{;�cN��sh}�
��A~
ӻ�N���r���)�2�Q_��,6��y����bw�GI����h���������?���@����J��O�������A��n���}�j5�F��Zm١��6�'~��P��vҩ{��_wuCW�5r�\ًdb�>�/��4^F�r}�H�vU� ���n�]E��k��U�������8]g߯�/!���?�:�+nd/���lR�rk=�F�(�u��8s}�����ꝟ��}��|�����:�s^�ʩ�X|=�M�jWީ��b����dW��o}���^����Oo�vT�
׾��TT��nG���w����j���.����4DU�A�#�Q�����7����b��/��hv�oGپVU�;?��Z��u�i�]�>ʵ�(��ˍ���{��{�@���ڂ�?oA�%wۋ0:���o��X<���^~�c�[&-����֋{�����!?�փ����ӷ�^M�v����痲����5�X��W[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.L������ÓO,aa��!D~d�f�j��G�>���o�pD�=u��é��p�s�a໺x�7���]A�G"?0DCV�����=��uUqd|[���iS)tF�ue���YNw_a�����)�n��ٓ��*��=���j��E�o�jc]'�8\.��s�r(A.��.�/]׽t�H׭�N�m������u��n�i�NLPb��/Ac�&A#�DL����Q�(�@B�Q���m��g;���9.�}nrO����>��Ͽ����ыM�3���&�+7�fPB@�!bWH?K$d,�³���`�^�5��db�K�t$�uk[֎	������������x��}3-�Y�.-`�@��l^���<<��M�9��]L�aG[�UY���o�Ϳ�k�98Q7N���9䖙I��*E7 �G�o0�`5S��#KFl�M�M]�{�*i ����Ǚ���9�%	J��h2��n�B2MѺ�|b\�z��Wَ�~�x7�s�M8ZFL�5���qUfMi�<"�*��@�3�2l����Y#~��y�-��!c�Q��U�.��us�5FSd9�"l4]�!�[4]h�p�N�f��Ԇӣ��oN��8u�#8���i��N�-����e;�~Q�؁�ʝVeQo߃�0�}����Z�1u�c]�t����$�J�8R���[���u�p8��l���)U6^�5�}3��(�tn�~������G�JTx�Sk�Q�!��2ifqt��h>_[��E�/�0�g�����!��a���|�X�.�"��5J��A����5�P�kN����~FhNf�r�_�Ԟk{�z&_G��f���pc�Q��;�<��s�����F�?I���`�cNJ��XȐ���kv���z����{�3��7��;^k���{�}C�����wu�^�]�_��:|����Yޮ��,�:sNN�+zU5�g�f��h�8��\^!�=��h����v�ݪc��?nԘ�;��5�������	���ډ�Sk�����_���R�l#U���qU��l�E�������nl���h��z�}ժK0_�p~��p(�g���4�w������8�������~S��_���?�B�g(�[���3'�f�~�^��ݸ8��?:�2�9}��Ĺ���?y �1��ڧǛ�������Oq�z=��F�<����zt=֣��^�k�f����4?��=,����f6~��LWoX@t�@�l��fކݱD�-v�8J�3����yk;=d�B�ij�,�r̗���*���0M��<�e��zpr����b4^2H|��9��-X
�D�mt�;��(L)�U8��D���,��1%:���E�`��ޚE!�Ig}%��L��JeO����(!�(�E���T�%Ą�g�RPR����URU�b�|�x���R��[/�(<˥��}�ӧl&�̈́����0a��D�퐁�Ծ���SGXkSOpHt�No������\	Y��!&8�Mהlč��x2�IJ�m"�]��q�kq��W6Q&���$*���FO�5�#���	�ن;�OH$@�p�J2��F��̴� H�ڑ��<|�C�=�3�c`sȊw"�09@���"B`��:hY!��b�X�GH�i�XM��0����J���=�.WM7�:���� E3|~��컍滯,�cR�%��(˖;���H�,��N�d0�݉���P@����׊���1�f�V�ʇ�b�%6�`!N�.���E�\YTAs�:����D絢DE�p!UM�>&�gZRjNY���.U����C�bM��$�u��*�r �a��D�r��7iGLe�Ŝw'����T�d��GrM����I�/��\U!p�U��"e�/P����R_AY�h��3�oU�<J�n?�%41t'��Pk���+i�oᅡ��0�D���N��V�U6��vPw�I4��p��5)6��^T�e��F��+�)s2�,{�gd�*ڄ�C���X�֧��*�to��{E�A����fn:��C� ~�!�;>"�ך*�&���S�{�b$��r$ܞd��`�S����>�����m����D�5���U�tn�JhZ�N�O�]�q�n�U����#���eo�ʳ��γ~�tUi�������uA�͉F�]�k��n���Y"w�3�ʛ��R�T��MЍ���x��K���Ɲ�&bSH�Z[��_54hm���	���:Zv���:t
��dI�D��Z�5�ڐ�n�N����~9����6�V眅ά]������pCР �Y�V1[�]�_k=���n�d�'�e&OqY9�s��i\Q��U��y�e����~�yh�Z�(���3rBg W����G��cd�+~�C�qyy{zk���ny�K��R��K��ݣ���t�$�z���
A"�o��[����±/<h�#!Җ:����A�\t0���<�)�U,�Ypp�h��.88i0=��fMD�'�z�3��ᦇ��3�6�F�HzUQ�+�(G�[Z���8!��{��
���-"G��R���m�N'5����
�{LU������R�S`�����!<��1>~�!i��{��p�X8��I�A�����Lt��U]�Vb��L-G2�X��H_���w�	E�@%�W�ޖ��2Ά=Hvq�l�������?Іh'���^L�Du��5����m0M����pVn`��Tӊ�t���5�m�q��q������nӝ�[���ӆ?4vL�sL|�s �gwt�.x�T���V�]�w�a�����o�?9F��y�����xXv$�I[u�LG�F)\I"��rI&ZǼ� �S ��78�;X̠�`)*�q��g�"��8jPd�*0
�L7kʲ���al���`6¨M%��)e'.�Ƞ4F�)�)�S[� w�
Sb>ZvQ� �e�K�F�=\����`��E�t)%!TLG�����p�`�n,�(t��0�v�&Djl�ɷ�����!QW��m#(����K;� �{Ų�vG��W�R��'y9X(#.8�$����aFD�ʖ\�o��Ú�ؒp8��&K�Z�^�E��nw��%R�wi�=,�8l��3�Cy?�و�JN���N�L�B_+��V�m\��a��f��&�ZB��v�vG5��k���S���&^������k7��g����y�>.�Y��	A�8���n���+���sqT�I��8	�����܋�bv���o��j�pǧ��o������K/���?]k�]�{�^���4�NT?�:��޽��<6��$��p<��~� �}��?���O?��o�����j��Oϟ��O��w��n]�����_�\��m^M'�U�����_�ɏ=���亂?���k�����7>�$�:^��?RП���/8�7g�����N��iS;m��M����W���W\; m�mj�M������f�l�j�����z���Uh�~p�0B�\���5�E��I�c �[������>�~�������kSԄ!�g`�u6����jJ�y�q�������<k�r�,�뵩i6�<-{Όm������i���8l�sf�0��S`.�̜��;DhmU��K=F2�q�K�ZW����Nv���޷���6H  