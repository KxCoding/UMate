//
//  Termsandconditions.swift
//  UMate
//
//  Created by 황신택 on 2021/07/28.
//

import Foundation

enum TermsOfService: String {
    case service
    case privacy
    case location
    case termsofservice
    case privacypolicy
    case locationbasedservices
    case agreednotification
 
}

class LocalStorage {
    
    private init() { }
    
    static let database = LocalStorage()
    
    var service: String = """
                        UMATE 서비스 이용약관
                        UMATE 서비스 이용 약관은 관계법령의 규정을 반영하여 아래와 같이 내용을 정하고 있습니다.
                       이 이용 약관은 웹 사이트나 모바일 어플리케이션 등 주식회사 TaekToy(이하 "회사")에서 제공하는 ‘UMATE’서비스에 적용되는 것으로 회원과 회사간에 적용됩니다. 따라서 회원 가입 및 서비스 이용 전에 전체 내용을 주의해서 읽어 보십시오. 회사는 아래의 내용에 동의하시는 회원에 한하여 정상적인 서비스를 제공할 수 있습니다. 내용에 동의하지 않으면 UMATE에서 제공하는 모든 서비스에 대한 이용이 불가능합니다.
                       제 1 조 목적
                         이 약관은 회사가 제공하는 서비스 이용과 관련하여 회사와 회원의 가입, 사용 시 권리와 의무, 책임사항 등 기타 필요한 사항을 규정함을 목적으로 합니다.
                       제 2 조 용어의 정의
                         a. 회원: 회사의 서비스를 이용하기 위해 가입행위를 하여 회원 계정을 소유하며 약관에 따른 권리와 의무를 갖는 자를 말합니다.
                         b. 회원 계정: 회원이 UMATE 서비스를 이용하기 위하여 회원이 정한 이메일 기반의 고유 식별 기호입니다.
                           * 회사의 공지 및 변동사항에 대해서는 회원 계정인 이메일로 발송되기에 본인의 계정이 사용 가능한 이메일 형식이 아니거나 본인이 확인을 할 수 없는 이메일계정을 등록하여 발생하는 불이익은 전적으로 회원의 귀책사유가 됩니다.
                         c. 서비스: 서비스라 함은 구현되는 단말기(PC, TV, 휴대형단말기 등의 각종 유무선 장치를 포함)와 제공 형태(웹사이트, 모바일 어플리케이션 등)에 상관없이 회원이 이용할 수 있는 UMATE 및 UMATE 관련 제반 서비스를 의미합니다.
                         d. 이메일인증: 회원이 UMATE에 가입 시, 회사는 기본적인 회원의 정보를 위탁기관을 통해 인증할 의무를 가지되 공신력이 없으므로 회원이 허위나 부정한 정보를 입력하여 이메일인증을 받은 경우 회사는 이메일인증에 관하여 법적 책임을 부담하지 않습니다.
                       제 3 조 약관의 효력
                         a. 효력 발생: 이용자가 회원 가입함과 동시에 효력이 발생합니다. 관계법령에 위배되지 않는 범위 안에서 개정이 될 수 있으며, 이는 서비스 공지사항 및 이메일로 통보하여 효력을 인정 받습니다.
                         b. 회원의 이 약관에 대한 동의는 UMATE 웹 사이트나 모바일 어플리케이션을 방문하여 약관의 변경 사항을 확인하는 것에 대한 동의를 포함합니다.
                         c. 회원은 개정된 약관에 동의하지 않을 경우 UMATE에게 계약해지 및 탈퇴를 요청 할 수 있으며, 계속 서비스를 사용할 경우 변경된 약관에 동의하는 것으로 간주됩니다.
                       제 4 조 약관 외 준칙
                         이 약관에 명시되지 않은 사항은 전자거래기본법, 전자상거래 등에서의 소비자 보호에 관한 법률, 약관의 규제에 관한 법률, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 기타 관련법령의 규정에 따릅니다.
                       제 5 조 회원 가입
                         a. 회원이 되고자 하는 자는 “약관에 동의” 및 이메일인증 후 회원의 기본정보 입력단계를 거쳐 회원 가입을 신청합니다.
                         b. 회원이 입력한 정보는 사실로 간주됩니다. 회사는 회원이 입력한 정보의 내용이 사실과 다를 경우(차명, 비실명, 허위정보 등)와 타인의 정보를 도용한 것으로 의심되는 경우, 사실 여부를 확인하기 위해 회원에게 입증자료 제출 및 해명을 요구할 수 있으며 상이한 사실이 명백하게 확인 되는 경우, UMATE는 회원으로부터 회원의 권한을 박탈하며 서비스 이용을 전면적으로 거부 할 수 있고, 이로 인해 발생하는 모든 불이익에 대해서는 회사가 책임지지 않습니다.
                         c. 회사는 회원의 상태와 이용기간, 이용횟수, 서비스 접근 방식 등에 따라 합리적인 기준을 통해 서비스 범위에 차등을 둘 수 있으며, 회원은 상기 내용에 따라 서비스 이용에 제약을 받을 수 있습니다.
                         d. 회사는 A항의 방법으로 회원가입을 신청한 이가 아래의 각 호에 해당하는 경우 회원가입 승낙을 유보 또는 거부할 수 있습니다.
                           1. 타인의 실명인증 정보 도용, 사진 도용 등 등록내용을 허위로 기재한 사실이 있는 경우
                           2. 가입 신청자가 UMATE 약관 및 서비스 이용에 관한 관계법령을 위반하여 UMATE 서비스의 회원자격을 상실한 경우
                           3. 사회질서 및 미풍양속을 문란하게 한 자
                           4. 영리 추구를 목적으로 UMATE 서비스에 가입 하고자 하는 자
                           5. 금치산자 및 한정치산자 기타 이에 준하는 자
                           6. 기타 회사의 여건상 이용승낙이 곤란하거나 가입결격 사유에 해당하는 자.
                           ** 개정 "주민등록법"에 의해 타인의 주민등록번호를 부정 사용하는 자는 3년 이하의 징역 또는 1천만원 이하의 벌금이 부과될 수 있습니다. 관련법률: 주민등록법 제37조(벌칙) 제10호(시행일 2009.04.01)
                         e. 회원가입 계약 성립 시점은 회사의 가입 승낙이 가입 신청자에게 도달한 시점을 기준으로 합니다.
                       제 6 조 회원 모니터링
                         a. UMATE에서는 이메일인증을 완료한 회원들을 중심으로 서비스하게 됩니다. 따라서 이메일인증을 완료하지 못한 회원들은 UMATE에서 준비한 서비스를 제공받기 위하여 준비중인 단계에 있는 것이며, 서비스 이용에 제한이 있을 수 있으며 해당 상태의 회원에게는 이메일 등의 수단으로 을 돕기 위한 행위가 이루어 집니다.
                         b. 회원가입 이후에도 회원의 프로필 수정에 대한 모니터링이 이루어지며 심사 및 모니터링 시점에서 프로필 관리 목적에 필요한 경우 심사 담당자에 의해 프로필의 작성내용이 수정 및 삭제될 수 있습니다.
                         c. 회사는 회원이 작성한 닉네임이 1) 개인정보 유출 우려가 있거나, 2) 반사회적 또는 미풍양속에 어긋나거나, 3) 회사 및 회사의 운영자로 오인될 우려가 있거나, 4) 작성과정 상의 문제로 인해 제대로 입력되어있지 않은 경우 해당 닉네임에 대한 사용을 제한 하거나, 관리자가 해당 닉네임을 수정 및 삭제할 수 있습니다.
                       제 7 조 서비스의 종류 및 범위
                         a. 회원은 무료로 UMATE서비스에 가입하여 일반 회원이 될 수 있습니다. 단, 프리미엄서비스 등의 새로운 가입 조건이 생성되면 유료 가입 역시 가능 할 수 있습니다.
                         b. 회원가입 후, 운영 상의 절차를 마친 회원은 무료로 검색옵션에 부합하는 상대방을 소개받을 수 있습니다.
                         c. 서비스는 연중무휴, 1일 24시간 제공을 원칙으로 합니다.
                         d. 회사에서는 양질의 서비스 제공을 위해 회원 프로필의 수정 및 보완을 요청할 수 있으며 당사의 내부 규정에 따라 부적합한 프로필을 작성한 회원에게는 서비스 이용을 제한 할 수 있습니다.
                         e. 회사는 회원이 입력한 프로필 정보에 대해 신원 인증을 요청할 수 있습니다. 프로필 정보에 대한 신원 인증은 회사가 정한 신원인증서류를 회원이 회사에 제출하거나, 회원이 자신이 입력한 프로필 정보에 대해 재확인 및 동의 절차를 거치는 방법으로 이뤄집니다. 신원 인증의 방법과 절차에 따라 별도의 신원 인증비를 회원에게 요청할 수 있습니다. 신원인증일 이후부터 서비스 이용일 현재까지의 개인정보의 정확성에 대해서는 회사가 알지 못하며 회원 본인의 개인정보에 대해 최신의 정확한 개인정보로의 유지, 갱신의 의무는 회원 본인에게 있습니다. 이로 인해 발생한 문제의 책임은 회원에게 있으며 회사는 책임을 지지 않습니다. 회사는 관련 문제로부터 발생한 대내외적 손실에 대한 법적 책임을 해당 회원에게 물을 수 있습니다.
                         f. 회사가 제공하는 UMATE서비스는 UMATE의 웹사이트 및 모바일 어플리케이션 상에서의 프로필 열람 및 대화방 서비스를 제공하는 것을 그 범위로 합니다.
                         g. UMATE에서 연결된 뒤 회원들간 행위(연락 및 만남)의 책임은 당사자에게 있습니다. 따라서 실제 연락이나 만남의 장소와 시간 등은 신중하게 결정해야 합니다.
                         h. 회사는 UMATE에서 연결된 뒤에도 서비스를 악용하거나 약관 혹은 법령상의 제한을 위반하는 회원의 서비스 이용을 제한하기 위하여 신고메뉴를 운영하고 있습니다. 비록 제 7조 g항에 따라 회원간의 만남에 있어 회원들간의 행위의 책임은 해당 회원에게 귀속되지만, 신고가 접수되고 신고된 회원의 행위가 추후 다른 회원에게 추가적인 피해를 입힐 수 있다고 판단되는 경우에는 문제의 회원들에 대하여 이용 제한, 탈퇴, 아이디 영구삭제, 법적 책임 추궁 등의 후속 조치를 취할 수 있습니다.
                       제 8 조 결제, 환불 및 결제 취소
                         a. 회원은 회사가 제공하는 다양한 결제수단을 통해 유료서비스를 이용할 수 있으며, 결제가 비정상적으로 처리되어 정상처리를 요청할 경우 회사는 회원의 결제금액을 정상처리 할 의무를 집니다.
                         b. 회사는 부정한 방법 또는 회사가 금지한 방법을 통해 충전 및 결제된 금액에 대해서는 이를 취소하거나 환불을 제한할 수 있습니다.
                         c. 회원은 다음 각 호의 사유가 있으면 아래의 D항의 규정에 따라서 회사로부터 결제 취소, 환불 및 보상을 받을 수 있습니다.
                           1. 결제를 통해 사용할 수 있는 서비스가 전무하며 그에 대한 책임이 전적으로 회사에 있을 경우 (단, 시스템 정기 점검 등의 불가피한 사유로 인한 경우는 제외)
                           2. 회사 또는 결제대행사의 시스템 오류로 인하여 결제가 중복으로 이루어진 경우
                           3. 서비스 중단 등 회사의 잘못으로 인해 회사가 회원에게 해지를 통보하는 경우
                           4. 기타 소비자 보호를 위하여 당사에서 별도로 정하는 경우.
                           5. 회원이 유료 결제 후 7일 이내에 환불 요청을 하는 경우
                         d. 회사는 제8조 C항 각호에 해당하는 경우라 할지라도 아래 각 항목에 해당하는 경우 환불 및 결제 취소 처리하지 않습니다.
                           1. 다른 이용자로부터 선물 받은 아이템의 경우
                           2. 이벤트 당첨 또는 참여로 적립 받은 아이템의 경우
                           3. 서비스 내에서 활동 등으로 회사로부터 적립 받은 경우
                           4. 기타 이용자가 직접 유료 결제하지 않은 경우
                           5. 아이템의 유효기간이 만료되어 소멸된 아이템의 경우
                           6. 회원이 이용약관 및 정책을 위반하여 이용정지 및 강제탈퇴 되는 경우
                           7. 회원의 자진탈퇴로 인해 계약이 해지되는 경우
                       제 9 조 회사의 의무
                         a. 회사는 지속적이고 안정적인 서비스 제공을 위해 최선을 다합니다.
                         b. 회사는 회사가 정한 약관 및 운영 정책 혹은 법령을 위반하는 회원들을 강제 탈퇴조치 하거나 혹은 관계 법령에 따라 법적 절차를 진행할 의무를 가집니다.
                         c. 회사는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관계법령에 따라 회원이 회원 가입 신청 시 기록한 개인정보, 이후에 추가로 기록한 개인정보 및 서비스 이용 중 생성되는 개인정보를 보호하여야 합니다.
                         d. 회사의 임직원은 서비스 제공과 관련한 회원의 개인정보를 UMATE회원 외에는 제3자에게 누설 또는 배포해서는 안되며 이를 어길 시 직위해제의 사유가 될 수 있습니다.
                         e. 회사는 정기적으로 회원에게 당사의 서비스 내용 및 이용 안내에 대한 정기적인 서신을 보냅니다. (공지, E-mail 등)
                         f. 회사는 이용계약의 체결, 계약사항의 변경 및 해지 등 회원과의 계약관련 절차 및 내용에 있어 이용고객에게 편의를 제공하도록 최선을 다합니다.
                         g. 회사는 UMATE 가입 시 회원에게 사전 서류심사(미혼,학력,직장정보에 관한)를 하지 않습니다. 하지만 서비스 신뢰도를 유지하고 다수의 선량한 회원을 보호하기 위해 가입한 회원의 정보가 기재 한 사항과 상이함이 의심되는 경우 이를 확인하고 제재하기 위한 절차와 법적으로 가능한 범위 내의 조치를 다합니다.
                       제 10 조 회원의 의무
                         회원 가입 시 작성하는 개인 정보와 프로필(사진과 키워드 등)은 사실이어야 합니다. 또한 일정기간이 경과한 뒤 변경되는 개인 정보는 지속적으로 본인이 정보를 갱신하여야 합니다. 이에 성실히 이행하지 않음으로 인해 발생하는 불이익은 회원 본인의 책임입니다.
                           a. 회원이 직접 입력한 개인정보는 진실하여야 하며 만일 회원이 허위 기타 부정한 정보를 입력하여 다른 UMATE 회원에게 피해가 발생할 경우 그에 대한 민/형사상의 책임을 포함한 일체의 책임은 회원 본인에게 귀속됩니다.
                           b. 회사는 회원 정보에 대한 보증을 하지 않습니다. 또한, 회원간의 만남에 발생한 문제의 책임은 전적으로 회원 본인에게 귀속되기에 신중히 검토한 후 서비스를 이용해야 합니다.
                           c. 회원은 항상 UMATE의 공지 내용을 숙지하여야 합니다. 위 의무를 성실하게 이행하지 않음으로 인해 발생한 문제에 대한 책임은 회원에게 귀속됩니다.
                           d. 회원은 아래 각 호에 해당하는 행위를 해서는 안됩니다.
                             1. UMATE 사이트의 회원정보를 부정하게 취득하는 행위
                             2. UMATE 홈페이지 혹은 애플리케이션을 기타 해킹 또는 유사 프로그램을 이용하여 정상적인 운영을 어렵게 하는 행위 (예: 해킹 또는 바이러스 유포, 디도스 공격 등)
                             3. 타인의 주민번호, 계정 혹은 비밀번호를 도용하는 행위.
                             4. 개인 정보를 허위 또는 타인의 것으로 등록하는 행위.
                             5. 상대방에 대한 비방 또는 인격모독을 하거나 이를 작성 및 유포하는 행위.
                             6. 공공질서, 미풍양속을 저해하는 저작물을 등록 또는 유통시키는 행위.
                             7. 사이트 내에서 불법적으로 물건을 판매하거나 상행위를 하는 행위.
                             8. 음란물 및 동영상을 게시하는 행위.
                             9. UMATE가 제공하는 프로필 및 개인 정보(키워드, 사진, 이름, 연락처, 등)을 무단 캡처(저장) 하는 행위 및 이를 유출하여 외부에 게시하는 행위
                             10. UMATE에 대한 허위 사실을 유포하거나 기타의 방법으로 업무를 방해하는 행위
                             11. 기타 UMATE 서비스 및 제반 설비를 이용하여 범죄 또는 불법행위를 하는 행위.
                           이상 위 D항 각 호 해당 사항에 명시한 내용을 위반한 회원은 강제 탈퇴 처리될 수 있으며 민/형사상의 책임을 지게 됩니다.
                           e. UMATE 회원의 권한은 타인에게 양도 및 판매가 불가능합니다. .
                           f. 본 약관을 위반 하거나, 기타 대한민국 관계 법령에 위반하는 행위에 대해서는 경고 없이 회원의 권한이 박탈되며, 이에 대해 회사는 회원에게 어떠한 보상도 하지 않습니다.
                       제 11 조 계약의 종료
                         UMATE는 다음과 같은 조건을 계약의 종료 조건으로 인정합니다.
                           a. 회원의 자의에 의한 탈퇴 신청 (홈페이지 탈퇴 및 자신의 의사를 회사에 피력한 경우)
                           b. 회원의 의무를 성실하게 이행하지 않거나, 약관에서 정한 사항 및 정책에 위배되는 행위를 한 회원은 사전 고지 없이 강제 탈퇴 처리될 수 있습니다.
                           c. 회원 여건상 지속적인 계약 이행이 어렵다고 판단될 경우 임의 계정 중지 및 해지 처리할 수 있습니다. (예: 사망 또는 행방불명, 일정 기간 이상 활동을 하지 않는 휴면 회원 등)
                           d. 기타 회원이 제 5조 D항에 해당하는 행위를 하는 경우 회사에 의해 계약이 종료될 수 있습니다.
                       제 12 조 면책조항
                         a. 회사는 운영상 또는 기술상의 필요에 따라 제공하고 있는 서비스를 변경할 수 있습니다. 변경될 서비스의 내용 및 제공일자 등에 대해서는 회사가 운영하는 홈페이지에 게시하거나 E-mail로 회원에게 통지합니다. 단, 회사가 사전에 통지할 수 없는 치명적인 버그 발생, 서버기기결함, 긴급 보안문제 해결 등의 부득이한 사정이 있는 경우에는 사후에 통지할 수 있습니다.
                         b. 회사는 다음 각호에 해당하는 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.
                           1. 전시, 사변, 천재지변 또는 국가 비상사태 등 불가항력적인 사유가 있는 경우
                           2. 정전, 제반 설비의 장애 또는 이용량의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 경우
                           3. 서비스용 설비의 보수 또는 공사 등 부득이한 사유가 있는 경우
                           4. 회사의 제반 사정으로 서비스를 할 수 없는 경우
                         c. 회사는 서비스 개편이나 운영상 또는 회사의 긴박한 상황 등에 의해 서비스 전부나 일부를 중단할 필요가 있는 경우 30일 전에 홈페이지에 이를 공지하고 서비스의 제공을 중단할 수 있습니다.
                         d. 회사는 기간통신 사업자가 전기통신 서비스를 중지하거나 정상적으로 운영을 하지 못해 발생하는 문제에 대하여 책임이 면제됩니다.
                         e. 회사는 회원의 귀책사유로 인한 서비스 이용 장애에 대한 책임을 지지 않습니다.
                         f. 회사는 회원이 회사의 서비스 제공으로부터 기대되는 이익을 얻지 못하였거나, 서비스 내용을 숙지하지 못하여 발생하는 손해 등에 대해서는 책임을 지지 않습니다.
                         g. 회사는 회원이 작성한 프로필에 대해 회사가 별도로 인증함을 고지하지 않은 경우 신뢰도 및 정확도 대한 책임을 지지 않으며 이로 인해 발생한 정신적, 물질적 손해 등의 피해에 대한 책임이 면제됩니다.
                         h. 회사의 게시물에 회원이 게재한 글의 저작권은 회원 본인에게 있으며, 게시물의 진실성이나 명예훼손, 저작권 위반과 같은 문제가 발생하여 벌어지는 민?형사 상의 모든 책임은 회원 본인에게 있습니다.
                         i. 회사는 회원의 서비스 이용에 필요한 서버의 보수로 인한 교체, 일시 정지, 개편 작업이 발생할 경우에는 서비스 중지에 대한 책임이 면제 됩니다.
                         j. 회원이 서비스 중인 홈페이지의 공지사항 등을 확인해야 하는 의무를 게을리하여 그 내용을 숙지하지 못하여 발생하는 문제의 책임은 회원 본인에게 있습니다.
                         k. 회사는 회원 신원을 보증하지 않습니다. 또한 회원이 다른 회원에게 경제적, 정신적, 물질적 피해를 가해도 그 책임은 가해자인 회원에게 있습니다.
                         l. 회사의 사이트에 배너광고 등으로 게재된 제3의 사이트 주소로 링크된 곳에서 발생하는 현상에 대해 회사는 어떠한 통제권도 가지지 않으며 해당 사이트의 운영방침에 따릅니다. 이로 인하여 발생하는 문제에 대한 책임은 해당 사이트와 회원 본인에게 있습니다.
                         m. 회사는 회원이 본 약관 규정을 위배하여 발생한 손실에 대해서는 책임을 지지 않습니다.
                         n. 회원이 공개를 허락한 자료에 대해 발생되는 모든 문제에 대해서는 회사의 책임이 면제 됩니다.
                         o. 회사의 동의 없이 제3자에게 계정 또는 회원의 권한을 판매 및 양도할 경우 회원 자격 박탈 및 민사청구 및 형사상의 고소 또는 고발이 가능합니다. 또한 이로 인한 모든 피해는 불법으로 회원권한을 판매/양도한 회원에게 귀속됩니다.
                         p. 회원이 작성한 아이디가 본인이 확인 가능한 이메일이 아니거나 연락처 갱신을 하지 않아 회사가 전달하는 공지사항이 그 전달방법인 E-mail을 통해 전달되지 못하여 발생하는 손해에 대한 책임은 회원 본인에게 있습니다.
                         q. 회원 간 혹은 회원과 제3자 상호간의 온라인 및 오프라인상에서 이루어진 행위에 대해서는 회원 본인에게 책임이 있습니다. 이에 실제 만남이나 연락은 신중히 결정하여 장소, 시간, 상황에 맞춰 적절하게 만나시길 바랍니다.
                       제 13 조 준거법 및 재판관할
                       본 계약과 관련하여 발생하는 제반 분쟁 및 소송은 서울중앙지방법원을 제 1심 관할법원으로 하여 대한민국법에 따라 해결합니다.
                       부칙
                       본 약관은 2021년 01월 01일부터 적용됩니다.
                       2020년 05월 24일부터 시행되던 종전의 약관은 본 약관으로 대체됩니다.
                       이용약관 버전번호 : v.3.0
                       이전 서비스 이용약관 보기
            
            """
    
    var privacy: String = """
                        UMATE. 개인정보 처리방침
                     
                         주식회사 TaekToy(이하 "회사"라 함)는 개인정보 보호법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 정보통신서비스제공자가 준수하여야 할 관련 법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거한 개인정보취급방침을 정하여 회원 권익 보호에 최선을 다하고 있습니다. 회사의 개인정보취급방침은 다음과 같은 내용을 담고 있습니다.
                         
                        제1조 (수집하고 있는 회원의 개인정보)
                        가. 수집하는 개인정보의 항목
                              회사는 아래의 경우 개인정보를 수집합니다.
                        수집 위치
                        수집목적
                        수집항목
                        회원가입
                        서비스 가입 및 이용
                        이메일 계정 주소, 비밀번호, 이름, 성별, 생년월일, 국적,
                        모국어, 관심언어, 프로필 사진, 소개글, 전화번호
                        회원가입
                        SNS 간편 로그인
                        Facebook, Apple ID, Google ID
                        서비스 이용간
                        이벤트 참여 및 맞춤형 광고 콘텐츠 제공
                        ADID/IDFA
                        서비스 이용간
                        부정 이용자 관리 및 제재
                        위치좌표, IP 접속 정보, 등록 프로필 사진, 소개글, 인증을 위한 전화번호, 대화 메시지, 좋아요 기록, 제재 기록, 제재 사유, 영상정보(캡쳐화면) 등
                        서비스 이용간
                        위치 기반 이용자 추천
                        위치정보
                        서비스 이용간
                        기술적 오류 대응
                        단말기종, OS, 서비스 배포 버전, 계정, 이메일
                        서비스 이용과정이나 사업처리 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.
                        IP Address, 방문 일시, 서비스 이용 기록, 쿠키, 접속 로그, 불량 이용 기록, 앱 설치정보, 네트워크 위치정보 등
                        나아가 서비스 이용과정에서 다음과 같은 정보들이 수집될 수 있습니다.
                        신용카드 결제 시: 카드사명, 카드번호 등
                        휴대전화 결제 시: 휴대전화번호, 통신사, 결제승인번호 등
                        계좌 이체 시: 은행명, 계좌번호 등
                        기타 결제 수단: 간편결제 또는 선불시 계좌 번호 등
                        회사는 회원의 결제카드, 계좌번호 등 서비스 운영상 필요하다고 판단되는 회원의 정보에 대하여 정기적으로 유효성을 검사하거나 확인할 수 있습니다.
                        나. 개인정보 수집방법
                            회사는 다음과 같은 방법으로 개인정보를 수집하고 있습니다.
                        UMATE(UMATEF) 프로그램의 실행 또는 사용 과정에서 수집
                        홈페이지, 모바일앱, 서면양식, 팩스, 전화, 상담 게시판, 이메일, 이벤트 응모
                        협력회사로부터 공동 제휴 및 협력을 통한 정보 수집
                        생성정보 수집 툴(쿠키를 포함)을 통한 정보 수집
                        제2조 (개인정보의 수집 및 이용 목적)
                         회사는 아래와 같은 목적으로 서비스 제공을 위한 최소한의 개인정보만을 수집하며, 수집한 정보를 목적 외로 사용하거나, 이용자의 동의 없이 제3자에게 제공하는 등 외부에 공개하지 않습니다.
                            가. 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산에 활용합니다
                        - 컨텐츠 제공, 특정 맞춤 서비스 제공, 본인인증, 구매 및 요금 결제, 요금추심
                            나. 회원관리를 위해 일부 회원 정보를 활용합니다
                        - 회원제 서비스 이용 및 인증 서비스에 따른 본인확인, 개인식별, 불량회원의 부정 이용방지와 비인가 사용방지, 가입의사 확인, 가입 및 가입횟수 제한, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달
                            다. 신규 서비스 개발 및 마케팅, 광고에 활용합니다
                        - 신규 서비스 개발 및 인증 서비스, 맞춤서비스 제공, 통계학적 특성에 따른 서비스 제공 및 광고 게재, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 접속빈도 파악, 회원의 서비스이용에 대한 통계, 서비스의 유효성 확인
                            라. 사고발생시 원인 규명 및 처리를 위한 수집 및 이용
                        제3조 (개인정보의 제한적 공개 및 제3자 제공)
                        회사는 회원의 개인정보를 “제2조 (개인정보의 수집 및 이용목적)”에서 고지한 범위 내에서 처리하며, 회원의 사전 동의가 있거나 법령에 규정된 경우를 제외하고는 회원의 개인정보를 동의 범위를 초과하여 이용하거나 외부에 공개 또는 제3자에게 제공하지 않는 것을 원칙으로 합니다. 다만, 다음의 경우 주의를 기울여 회원의 개인정보를 제한적으로 공개할 수 있습니다.
                        UMATE(UMATEF) 서비스 이용 도중 회원간 식별을 위해 닉네임, 프로필 사진이 UMATE(UMATEF) 내 다른 회원에게 공개됩니다. 또한 생일, 국가, 언어, 계정 및 이메일 주소, 위치정보, 소개글 등이 공개될 수 있습니다. 이는 특정이 불가능하여 별도로 고지하여 동의받지 못함을 양해바랍니다.
                        회원이 페이스북,애플 계정을 연결한 경우에는 페이스북, 애플 연결 여부가 표시됩니다. 이 경우 제공 범위는 회원의 UMATE(UMATEF) 서비스 가입 여부로 한정되어 공개됩니다.
                        이용자의 생명이나 안전에 급박한 위험이 확인되어 이를 해소하기 위한 경우에 한하여 개인정보를 제공할 수 있습니다.
                         그 밖에 보다 나은 서비스 제공을 위하여 개인정보 제3자 제공이 필요한 경우, 법령 등에 다른 정함이 없는 한 사전에 정보를 제공받는 자, 정보를 제공받는 자의 개인정보 이용목적, 제공하는 개인정보의 항목, 개인정보를 제공받는 자의 개인정보 보유 및 이용기간, 정보제공 동의를 거부할 권리가 있다는 사실 및 동의 거부에 따른 불이익 등을 명시하여 동의를 구합니다. 제휴한 서비스에 제공하는 개인정보는 서비스를 제공하기 위해 반드시 필요한 정보로 한정합니다. 동의 시점에 서비스마다 제공되는 개인정보의 내용을 안내해 드립니다. 제공되는 개인정보의 내용은 서비스를 제공하면서 추가/변경될 수 있으며, 제휴 서비스를 사용하기 위해 필요한 개인정보가 변경되면 서비스 이용시 추가로 동의를 받습니다.
                        단, 개인정보를 제공받은 제3자는 제공 목적을 달성하거나 회원의 철회 요청이 있더라도, 내부보고, 감사 및 검사, 비용정산(청구) 등 계약이행, 분쟁 대비를 위해 필요한 정보는 해당 목적 달성시까지 개인정보를 보유∙이용할 수 있으며, 상법 등 관련 법령에 특별한 규정이 있을 경우 그에 의하여 보관할 수 있습니다.
                        제4조 (개인정보의 취급위탁)
                          가. 회사는 원활하고 향상된 서비스를 위하여 개인정보 처리를 타인에게 위탁할 수 있습니다. 이 경우 회사는 사전에 다음 각 호의 사항 모두를 이용자에게 미리 알리고 동의를 받습니다. 다음 각 호의 어느 하나의 사항이 변경되는 경우에도 같습니다.
                        ①       개인정보 처리위탁을 받는 자
                        ②       개인정보 처리위탁을 하는 업무의 내용
                         나. 회사는 정보통신서비스의 제공에 관한 계약을 이행하고 이용자의 편의 증진 등을 위하여 필요한 경우 개인정보처리방침에 따라 가항 각 호의 사항을 공개함으로써 고지절차와 동의절차를 거치지 아니하고 개인정보 처리를 타인에게 위탁할 수 있습니다.
                         다. 회사는 개인정보의 처리와 관련하여 아래와 같이 업무를 위탁하고 있으며, 관계법령에 따라 위탁 계약 시 개인정보가 안전하게 관리될 수 있도록 필요한 조치를 하고 있습니다. 회사는 위탁 계약 시 수탁자의 개인정보 보호조치 능력을 고려하고, 개인정보의 안전한 관리 및 파기 등 수탁자의 의무 이행 여부를 주기적으로 확인합니다. 또한 위탁처리하는 정보는 원활한 서비스를 제공하기 위하여 필요한 최소한의 정보에 국한됩니다.
                        서비스 이용을 위해 국내 업체에 개인정보의 처리를 위탁하는 경우
                        위탁업체
                        위탁업무 내용
                        GOOGLE
                        본인 인증 SMS 발송
                        이용을 위해 해외 업체에 개인정보의 처리를 위탁하는 경우
                        위탁 업체
                        이용 목적
                        이전 국가
                        이전 일시 및 방법
                        이전 항목
                        보유 이용기간
                        AWS
                        유저 정보 및 행동 정보 저장
                        미국
                        네트워크를 통하여 개인정보가 업무 필요시에 전송
                        차단IP, 차단 디바이스 목록, 대화방 ID, 대화방 내용, 삭제 이미지, 이벤트 로그, 결제 정보, 푸시정보, 접속로그 및 활동정보,친구 소개 리스트, 반송된 메일
                        회원 탈퇴시 혹은 위탁계약 종료시까지
                        MongoDB, Inc
                        유저 정보 및 행동 정보 저장
                        미국
                        네트워크를 통하여 개인정보가 업무 필요시에 전송
                        유저 구매 로그, 유저정보(ID,email, 성별, 프로필 이미지 등),시스템 자동 차단 스팸 유저 ID
                        회원 탈퇴시 혹은 위탁계약 종료시까지
                        제5조 (동의의 거부권 및 거부 시의 불이익 고지)
                        회원은 개인정보 수집ㆍ이용에 관한 동의를 거부할 권리가 있습니다. 다만, 계약 체결 및 이행 등을 위해 필요한 최소한의 개인정보 수집ㆍ이용에 관한 동의를 거부하는 경우에는 서비스 이용이 불가능하거나 처리 업무가 지연되는 등의 불이익이 있을 수 있습니다.
                        또한 마케팅 활동 및 홍보를 위한 개인정보 수집ㆍ이용 및/또는 선택적 수집ㆍ이용에 관한 동의를 거부하는 경우에는 이벤트, 혜택에 대한 정보를 제공받지 못하거나 사은품ㆍ판촉물 제공, 제휴서비스 이용, 할인 혜택 적용 및 포인트 적립 불가 등의 불이익이 있을 수 있습니다.
                        ※ 본 제공 동의 이외에도 회사는 회원이 별도로 동의한 경우, 회원이 동의한 바에 따라 개인정보를 수집ㆍ이용하거나 제3자에게 개인정보를 제공할 수 있습니다.
                        제6조 (개인정보의 보유 및 이용기간)
                         가. 회사는 이용자의 개인정보를 원칙적으로 고지 및 약정한 기간 동안 보유 및 이용하며 개인정보의 수집 및 이용목적이 달성되거나 이용자의 파기 요청이 있는 경우 혹은 회원 탈퇴 시 지체 없이 파기합니다. 단, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지 보존합니다.
                        ① 회사 내부 방침에 의한 정보 보유
                        관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지
                        서비스 이용에 따른 채권·채무관계가 잔존하는 경우 정산 시까지
                        부정 이용 모니터링 및 배제에 필요한 정보의 경우 서비스 종료 시까지
                        : 부정 이용기록(불량 혹은 비정상,음란및유해컨텐츠 등록기록), 회원ID, 대화내용, IP, 로그기록 등
                        이벤트 중복 참여 방지를 위해 광고식별자(ADID / IDFA) 정보의 경우 서비스 종료 시까지
                        ② 관계법령에 의한 정보 보유
                        관련 근거
                        목적
                        수집항목
                        보유기간
                        통신비밀보호법
                        법원 영장을 통해 수사기관이 요청시 제공
                        서비스 접속기록, IP 등
                        3개월
                        전자상거래 등에서의 소비자 보호에 관한 법률
                        거래 증빙, 소비자 보호
                        계약 또는 청약철회 등에 관한 기록 보존
                        5년
                        전자상거래 등에서의 소비자 보호에 관한 법률
                        거래 증빙, 소비자 보호
                        대금결제 및 재화 등의 공급에 관한 기록 보존
                        5년
                        전자상거래 등에서의 소비자 보호에 관한 법률
                        소비자 대응 증빙, 소비자 보호
                        소비자의 불만 또는 분쟁처리에 관한 기록 보존
                        3년
                        전자상거래 등에서의 소비자 보호에 관한 법률
                        소비자 보호
                        표시/광고에 관한 기록
                        6개월
                        위치정보의 보호 및 이용 등에 관한 법률
                        위치정보 수집.이용,제공 사실확인
                        개인위치정보에 관한 기록 보존
                        6개월
                        나. 2015년 8월 18일부터, 회사는 1년 동안 회사의 서비스를 이용하지 않은 이용자의 개인정보는 ‘정보통신망 이용촉진 및 정보보호등에 관한 법률 제29조’ 에 근거하여 이용자에게 사전통지하고 개인정보를 파기하거나 별도로 분리하여 저장 관리합니다. 이용자의 요청이 있을 경우에는 위 기간을 달리 정할 수 있습니다. 단, 통신비밀보호법, 전자상거래 등에서의 소비자보호에 관한 법률 등의 관계법령의 규정에 의하여 보존할 필요가 있는 경우 관계법령에서 규정한 일정한 기간 동안 이용자 개인정보를 보관합니다
                        다. 회사는 (나)항 기간 만료 30일 전까지 개인정보가 파기되거나 분리되어 저장/관리되는 사실과 기간 만료일 및 해당 개인정보의 항목을 공지사항, 전자우편 등의 방법으로 이용자에게 알립니다. 이를 위해 이용자는 회사에 정확한 연락처 정보를 제공/수정하여야 합니다.
                        제7조 (개인정보 파기절차 및 방법 )
                         회사는 개인정보 보유기간의 경과 혹은 개인정보의 수집 및 이용목적의 달성 등 개인정보가 불필요하게 되었을 때에는 해당 개인정보를 지체 없이 파기합니다.
                         회사의 개인정보 파기절차 및 방법은 다음과 같습니다.
                            가. 파기절차
                        회원이 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 잠금장치가 있는 서류보관함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조)일정 기간 저장된 후 파기됩니다.
                        동 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다
                            나. 파기방법
                        전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.
                        종이에 출력된 개인 정보는 분쇄기로 분쇄하거나 소각을 통해서 파기합니다.
                        제8조 (회원 및 법정대리인의 권리, 의무와 그 행사방법)
                        이용자 또는 법정대리인은 회사에 대해 언제든지 자신 혹은 만 14세 미만 아동의 개인정보 보호 관련 권리를 행사할 수 있습니다. 이용자 또는 법정대리인은 회사의 개인정보 처리에 동의하지 않는 경우 동의 철회 혹은 회원 탈퇴를 요청할 수 있습니다. 단, 이경우 서비스의 일부 또는 전부의 이용이 어려울 수 있습니다.
                        ①         개인정보 조회, 수정을 위해서는 "개인정보변경"(또는"회원정보수정"등)을, 회원탈퇴를 위해서는 앱에서 "회원탈퇴"를 터치하여 본인 확인 절차를 거치신 후 직접열람, 정정 또는 탈퇴가 가능합니다.
                        ②         혹은 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락하시면 지체 없이 조치하겠습니다.
                        ③         이용자가 개인정보의 오류에 대한 정정을 요청하는 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제 3자에게 이미 제공한 경우에는 정정 처리 결과를 제 3자에게 지체 없이 통지하여 정정이 이루어지도록 하겠습니다.
                        ④         회사는 이용자 또는 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 "제6조 개인정보 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.
                        제9조 (개인정보 자동 수집 장치의 설치/운영 및 그 거부에 관한 사항)
                        [쿠키(Cookie)의 운용 및 거부]
                        가.   쿠키의 사용 목적
                        ①         회사는 개인 맞춤 서비스를 제공하기 위해서 이용자에 대한 정보를 저장하고 수시로 불러오는 '쿠키(cookie)'를 사용합니다. 쿠키는 웹사이트 서버가 이용자의 브라우저에게 전송하는 소량의 정보로서 이용자 컴퓨터의 하드디스크에 저장됩니다.
                        ②        회사는 쿠키의 사용을 통해서만 가능한 특정된 맞춤형 서비스를 제공할 수 있습니다.
                        ③        회사는 회원을 식별하고 회원의 로그인 상태를 유지하기 위해 쿠키를 사용할 수 있습니다.
                        나.   쿠키의 설치/운용 및 거부
                        ①         이용자는 쿠키 설치에 대한 선택권을 가지고 있습니다. 따라서 이용자는 웹브라우저에서 옵션을 조정함으로써 모든 쿠키를 허용/거부하거나, 쿠키가 저장될 때마다 확인을 거치도록 할 수 있습니다.
                        ②        쿠키 설치 허용 여부를 지정하는 방법(Internet Explorer의 경우)은 다음과 같습니다.
                        - [도구] 메뉴에서 [인터넷 옵션]을 선택합니다.
                        - [개인정보 탭]을 클릭합니다.
                        - [개인정보처리수준]을 설정하시면 됩니다.
                        ③        쿠키의 저장을 거부할 경우에는 개인 맞춤서비스 등 회사가 제공하는 일부 서비스는 이용이 어려울 수 있습니다.
                        [온라인 맞춤형 광고 서비스]
                        가.   모바일 앱 사용시 광고 식별자 수집
                        회사는 이용자의 ADID/IDFA를 수집할 수 있습니다. ADID/IDFA란 모바일 앱 이용자의 광고 식별값으로서, 사용자의 맞춤 서비스 제공이나 더 나은 환경의 광고를 제공하기 위한 측정을 위해 수집할 수 있습니다.
                        거부방법
                        예) Android: 설정 → 구글(구글설정) → 광고 → 광고 맞춤설정 선택 해제
                        iOS: 설정 → 개인정보 보호 → 광고 → 광고 추적 제한
                        나.   온라인 맞춤형 광고 서비스
                        회사는 다음과 같이 온라인 맞춤형 광고 사업자가 광고식별자 및 행태정보를 수집하도록 허용하고 있습니다.
                        1) 행태정보를 수집 및 처리하는 광고 사업자: AdColony, AdCrony, AdExchange, AdFit, AdMob, AdPie, AdView, Appier, AppLovin, BatMobi, Cauly ,Dawin, DU, Facebook, Facebook(Open Bidding), Five, Fyber, IronSource, MobFox, Mobon, Mobpower, Mobvista, Mopup, PubNative, Smaato, TAM ,TNK, UnityAds, Vungle, YeahMobi, YouAppi, ZPLAY Ads 등
                        2) 행태정보 수집 방법: 이용자가 당사 앱을 실행할 때 자동 수집 및 전송
                        제10조 (개인정보의 기술적/관리적 보호 대책)
                        회사는 이용자들의 개인정보를 처리함에 있어 개인정보가 분실, 도난, 유출, 변조 또는 훼손되지 않도록 안전성 확보를 위하여 다음과 같은 기술적/관리적 보호대책을 강구하고 있습니다.
                        가.        개인정보의 암호화
                               이용자의 비밀번호는 일방향 암호화하여 저장 및 관리되고 있으며, 개인정보의 확인 및 변경은 비밀번호를 알고 있는 본인에 의해서만 가능합니다. 주민등록번호, 외국인 등록번호, 은행계좌번호 및 신용카드번호등의 개인정보는 안전한 암호 알고리즘으로 암호화되어 저장 및 관리되고 있습니다.
                        나.        해킹 등에 대비한 대책
                               회사는 해킹 등 회사 정보통신망 침입에 의해 이용자의 개인정보가 유출되는 것을 방지하기 위해 침입탐지 및 침입차단 시스템을 24시간 가동하고 있습니다. 만일의 사태에 대비하여 모든 침입탐지 시스템과 침입차단 시스템은 이중화로 구성하여 운영하고 있으며, 민감한 개인정보는 암호화 통신 등을 통하여 네트워크상에서 개인정보를 안전하게 전송할 수 있도록 하고 있습니다.
                        다.        개인정보 취급자의 최소화 및 교육
                               회사는 회사의 개인정보 취급자를 최소한으로 제한하며, 개인정보 취급자에 대한 교육 등 관리적 조치를 통해 개인정보보호의 중요성을 인식시키고 있습니다.
                        라.        개인정보보호전담부서의 운영
                               회사는 개인정보의 효율적 보호를 위해 개인정보보호전담부서를 운영하고 있으며, 개인정보처리방침의 이행사항 및 개인정보 취급자의 준수여부를 확인하여 문제가 발견될 경우 즉시 수정할 수 있도록 노력하고 있습니다.
                        제11조 (개인정보관리책임자 및 담당자의 연락처)
                        귀하께서는 회사의 서비스를 이용하며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자 혹은 담당부서로 신고하실 수 있습니다.
                        회사는 회원들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다.
                        [개인정보 관리책임자]
                        •      이름 : 이민규
                        •      소속 : 주식회사 TaekToy
                        •      직위 : 개인정보 관리책임자
                        •      메일 : admin@UMATEf.com
                        기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.
                        •      개인정보분쟁조정위원회 (http://www.kopico.go.kr / 국번없이 118)
                        •      개인정보침해신고센터 (http://privacy.kisa.or.kr / 국번없이 118)
                        •      대검찰청 사이버범죄수사단 (http://www.spo.go.kr / 02-3480-2000)
                        •      경찰청 사이버테러대응센터 (http://cyberbureau.police.go.kr / 국번없이 182)
                         제12조 (분쟁 및 소송)
                        개인정보에 관련하여 발생하는 제반 분쟁 및 소송은 서울중앙지방법원을 제 1심 관할법원으로 하여 대한민국법에 따라 해결합니다.
                         제13조 (기타)
                        회사는 이용자에게 다른 웹사이트에 대한 링크를 제공할 수 있습니다. 다만, 링크되어 있는 웹사이트들이 개인정보를 수집하는 행위에 대해서는 본 "개인정보처리방침"이 적용되지 않습니다.
                         
                        제14조 (고지 의무)
                        회사는 개인정보처리방침에 대한 변경이 있을 경우에는 개정 개인정보처리방침의 시행일로부터 최소 7일전 앱내 공지사항 또는 홈페이지 공지사항, 이메일을 통해 고지합니다.
                         부칙
                        현 개인정보처리방침은 정부의 정책 또는 회사의 필요에 의하여 변경될 수 있으며 내용의 추가 및 삭제, 수정이 있을 시에는 시행 7일 전에 홈페이지 또는 이메일을 통해 사전 공지하며 사전 공지가 곤란한 경우 지체 없이 공지하며, 이 정책은 공지한 날로부터 시행됩니다. 다만, 개인정보의 수집·이용 목적, 제3자 제공대상 등 중요한 사항이 추가 및 삭제, 수정되는 경우에는 30일 전에 사전 공지하고, 30일이 경과된 후에 시행됩니다. 또한 당사는 개인정보의 수집 및 활용, 제3자 제공 등 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관련법령에 따라 고객의 별도 동의가 필요한 사항과 관련된 내용이 추가, 변경되는 경우에는 관련 법령에 따른 고객의 별도 동의를 받습니다.
                        개인정보처리방침 버전번호 : v.3.2
                        공고일자 : 2021년 04월 12일
                        시행일자 : 2021년 04월 19일
                         
                        이전 개인정보처리방침 보기
                
            
            """
    
    
    var location: String =
        """
                UMATEF 위치기반서비스 이용약관
                제1장 총 칙
                제 1 조 (목적)
                본 약관은 주식회사 TaekToy(이하 "회사")가 제공하는 위치기반서비스에 대해 회사와 위치기반서비스를 이용하는 개인위치정보주체(이하 "이용자")간의 권리·의무 및 책임사항, 기타 필요한 사항 규정을 목적으로 합니다.
                제 2 조 (이용약관의 효력 및 변경)
                  ① 본 약관은 서비스를 신청한 고객 또는 개인위치정보주체가 본 약관에 동의하고 회사가 정한 소정의 절차에 따라 서비스의 이용자로 등록함으로써 효력이 발생합니다.
                  ② 회원이 온라인에서 본 약관의 "동의하기" 버튼을 클릭하였을 경우 본 약관의 내용을 모두 읽고 이를 충분히 이해하였으며, 그 적용에 동의한 것으로 봅니다.
                  ③ 회사는 위치정보의 보호 및 이용 등에 관한 법률, 콘텐츠산업 진흥법, 전자상거래 등에서의 소비자보호에 관한 법률, 소비자기본법 약관의 규제에 관한 법률 등 관련법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.
                  ④ 회사가 약관을 개정할 경우에는 기존약관과 개정약관 및 개정약관의 적용일자와 개정사유를 명시하여 현행약관과 함께 그 적용일자 10일 전부터 적용일 이후 상당한 기간 동안 공지만을 하고, 개정 내용이 회원에게 불리한 경우에는 그 적용일자 30일 전부터 적용일 이후 상당한 기간 동안 각각 이를 서비스 홈페이지에 게시하거나 회원에게 전자적 형태(전자우편, SMS 등)로 약관 개정 사실을 발송하여 고지합니다.
                  ⑤ 회사가 전항에 따라 회원에게 통지하면서 공지 또는 공지∙고지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 이용약관에 승인한 것으로 봅니다. 회원이 개정약관에 동의하지 않을 경우 회원은 이용계약을 해지할 수 있습니다.
                제 3 조 (약관 외 준칙)
                이 약관에 명시되지 않은 사항에 대해서는 위치 정보의 보호 및 이용 등에 관한 법률, 전기통신사업법, 정보통신망 이용 촉진 및 보호 등에 관한 법률 등 관계법령 및 회사가 정한 지침 등의 규정에 따릅니다.
                제 4 조 (서비스의 내용)
                회사가 제공하는 서비스는 아래와 같습니다.
                 
                서비스 명
                서비스 내용
                UMATEF
                근처의 외국인 검색
                언어, 국적별 매칭
                채팅
                회사는 직접 수집하거나 위치정보사업자로부터 수집한 이용자의 현재 위치 또는 현재 위치가 포함된 지역을 이용하여 아래와 같은 위치기반서비스를 제공합니다.
                ① 위치정보를 활용한 정보 검색결과 및 콘텐츠를 제공하거나 추천
                ② 생활편의를 위한 위치 공유, 위치/지역에 따른 알림, 경로 안내
                ③ 위치기반의 컨텐츠 분류를 위한 콘텐츠 태깅(Geotagging)
                ④ 위치기반의 맞춤형 광고
                제 5 조 (서비스 이용요금)
                  ① 회사가 제공하는 서비스는 기본적으로 무료입니다. 단, 별도의 유료 서비스의 경우 해당 서비스에 명시된 요금을 지불하여야 사용 가능합니다.
                  ② 회사는 유료 서비스 이용요금을 회사와 계약한 전자지불업체에서 정한 방법에 의하거나 회사가 정한 청구서에 합산하여 청구할 수 있습니다.
                  ③ 유료서비스 이용을 통하여 결제된 대금에 대한 취소 및 환불은 회사의 결제 이용약관 등 관계법에 따릅니다.
                  ④ 회원의 개인정보도용 및 결제사기로 인한 환불요청 또는 결제자의 개인정보 요구는 법률이 정한 경우 외에는 거절될 수 있습니다.
                  ⑤ 무선 서비스 이용 시 발생하는 데이터 통신료는 별도이며 가입한 각 이동통신사의 정책에 따릅니다.
                  ⑥ MMS 등으로 게시물을 등록할 경우 발생하는 요금은 이동통신사의 정책에 따릅니다.
                제 6 조 (서비스 이용의 제한·중지)
                  ① 회사는 위치기반서비스사업자의 정책변경 등과 같이 회사의 제반사정 또는 법률상의 이유로 위치기반서비스를 유지할 수 없는 경우 위치기반서비스의 전부 또는 일부를 제한·변경·중지할 수 있습니다.
                ② 단, 위 항에 의한 위치기반서비스 중단의 경우 회사는 사전에 회사 홈페이지 등 기타 공지사항 페이지를 통해 공지하거나 이용자에게 통지합니다.
                제 7 조 (개인위치정보주체의 권리)
                  ① 이용자는 언제든지 개인위치정보의 수집·이용·제공에 대한 동의 전부 또는 일부를 유보할 수 있습니다.
                ② 이용자는 언제든지 개인위치정보의 수집·이용·제공에 대한 동의 전부 또는 일부를 철회할 수 있습니다. 이 경우 회사는 지체 없이 철회된 범위의 개인위치정보 및 위치정보 수집·이용·제공사실 확인자료를 파기합니다.
                ③ 이용자는 개인위치정보의 수집·이용·제공의 일시적인 중지를 요구할 수 있으며, 이 경우 회사는 이를 거절할 수 없고 이를 충족하는 기술적 수단을 마련합니다.
                ④ 이용자는 회사에 대하여 아래 자료에 대한 열람 또는 고지를 요구할 수 있으며, 해당 자료에 오류가 있는 경우에는 정정을 요구할 수 있습니다. 이 경우 정당한 사유 없이 요구를 거절하지 않습니다.
                1. 이용자에 대한 위치정보 수집·이용·제공사실 확인자료
                2. 이용자의 개인위치정보가 위치정보의 보호 및 이용 등에 관한 법률 또는 다른 법령의 규정에 의하여 제3자에게 제공된 이유 및 내용
                ⑤ 이용자는 권리행사를 위해 본 약관 제14조의 연락처를 이용하여 회사에 요청할 수 있습니다.
                제 8 조 (개인위치정보의 이용 또는 제공)
                  ① 회사는 개인위치정보를 이용하여 서비스를 제공하고자 하는 경우에는 미리 이용약관에 명시한 후 개인위치정보주체의 동의를 얻어야 합니다.
                  ② 회원 및 법정대리인의 권리와 그 행사방법은 제소 당시의 이용자의 주소에 의하며, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다.
                  ③ 회사는 타사업자 또는 이용 고객과의 요금정산 및 민원처리를 위해 위치정보 이용·제공․사실 확인자료를 자동 기록·보존하며, 해당 자료는 1년간 보관합니다.
                  ④ 회사는 개인위치정보를 회원이 지정하는 제3자에게 제공하는 경우에는 개인위치정보를 수집한 당해 통신 단말장치로 매회 회원에게 제공받는 자, 제공일시 및 제공목적을 즉시 통보합니다. 단, 아래 각 호의 1에 해당하는 경우에는 회원이 미리 특정하여 지정한 통신 단말장치 또는 전자우편주소로 통보합니다.
                    1. 개인위치정보를 수집한 당해 통신단말장치가 문자, 음성 또는 영상의 수신기능을 갖추지 아니한 경우
                    2. 회원이 온라인 게시 등의 방법으로 통보할 것을 미리 요청한 경우
                  ⑤ 제공목적은 검색된 결과로 나타나는 상대방의 위치노출을 위함이며, 제공받는 자란 서비스의 사용자가 특정한 조건으로 검색을 하여 그에 따른 위치정보 결과를 받아보았을 경우 그 사용자를 의미한다.
                제 9 조 (개인위치정보주체의 권리)
                  ① 회원은 회사에 대하여 언제든지 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치정보의 제3자 제공에 대한 동의의 전부 또는 일부를 철회할 수 있습니다. 이 경우 회사는 수집한 개인위치정보 및 위치정보 이용, 제공사실 확인자료를 파기합니다.
                  ② 회원은 회사에 대하여 언제든지 개인위치정보의 수집, 이용 또는 제공의 일시적인 중지를 요구할 수 있으며, 회사는 이를 거절할 수 없고 이를 위한 기술적 수단을 갖추고 있습니다.
                  ③ 회원은 회사에 대하여 아래 각 호의 자료에 대한 열람 또는 고지를 요구할 수 있고, 당해 자료에 오류가 있는 경우에는 그 정정을 요구할 수 있습니다. 이 경우 회사는 정당한 사유 없이 회원의 요구를 거절할 수 없습니다.
                    1. 본인에 대한 위치정보 수집, 이용, 제공사실 확인자료
                    2. 본인의 개인위치정보가 위치정보의 보호 및 이용 등에 관한 법률 또는 다른 법률 규정에 의하여 제3자에게 제공된 이유 및 내용
                  ④ 회원은 제1항 내지 제3항의 권리행사를 위해 회사의 소정의 절차를 통해 요구할 수 있습니다.
                제 10 조 (법정대리인의 권리)
                  ① 회사는 14세 미만의 회원에 대해서는 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치정보의 제3자 제공에 대한 동의를 당해 회원과 당해 회원의 법정대리인으로부터 동의를 받아야 합니다. 이 경우 법정대리인은 제9조에 의한 회원의 권리를 모두 가집니다.
                  ② 회사는 14세 미만의 아동의 개인위치정보 또는 위치정보 이용․제공사실 확인자료를 이용약관에 명시 또는 고지한 범위를 넘어 이용하거나 제3자에게 제공하고자 하는 경우에는 14세 미만의 아동과 그 법정대리인의 동의를 받아야 합니다. 단, 아래의 경우는 제외합니다.
                    1. 위치정보 및 위치기반서비스 제공에 따른 요금정산을 위하여 위치정보 이용, 제공사실 확인자료가 필요한 경우
                    2. 통계작성, 학술연구 또는 시장조사를 위하여 특정 개인을 알아볼 수 없는 형태로 가공하여 제공하는 경우
                제 11 조 (8세 이하의 아동 등의 보호의무자의 권리)
                  ① 회사는 아래의 경우에 해당하는 자(이하 “8세 이하의 아동”등이라 한다)의 보호의무자가 8세 이하의 아동 등의 생명 또는 신체보호를 위하여 개인위치정보의 이용 또는 제공에 동의하는 경우에는 본인의 동의가 있는 것으로 봅니다.
                    1. 8세 이하의 아동
                    2. 금치산자
                    3. 장애인복지법 제2조 제2항 제2호의 규정에 의한 정신적 장애를 가진 자로서 장애인고용촉진및직업재활법 제2조 제2호의 규정에 의한 중증장애인에 해당하는 자(장애인복지법 제29조의 규정에 의하여 장애인등록을 한 자에 한한다)
                  ② 8세 이하의 아동 등의 생명 또는 신체의 보호를 위하여 개인위치정보의 이용 또는 제공에 동의를 하고자 하는 보호의무자는 서면동의서에 보호의무자임을 증명하는 서면을 첨부하여 회사에 제출하여야 합니다.
                  ③ 보호의무자는 8세 이하의 아동 등의 개인위치정보 이용 또는 제공에 동의하는 경우 개인위치정보주체 권리의 전부를 행사할 수 있습니다.
                제 12 조 (위치정보관리책임자의 지정)
                  ① 회사는 위치정보를 적절히 관리․보호하고 개인위치정보주체의 불만을 원활히 처리할 수 있도록 실질적인 책임을 질 수 있는 지위에 있는 자를 위치정보관리책임자로 지정해 운영합니다.
                  ② 위치정보관리책임자는 위치기반서비스를 제공하는 부서의 부서장으로서 구체적인 사항은 본 약관의 부칙에 따릅니다.
                제 13 조 (손해배상)
                 
                  ① 회사가 위치정보의 보호 및 이용 등에 관한 법률 제15조 내지 제26조의 규정을 위반한 행위로 회원에게 손해가 발생한 경우 회원은 회사에 대하여 손해배상 청구를 할 수 있습니다. 이 경우 회사는 고의, 과실이 없음을 입증하지 못하는 경우 책임을 면할 수 없습니다.
                  ② 회원이 본 약관의 규정을 위반하여 회사에 손해가 발생한 경우 회사는 회원에 대하여 손해배상을 청구할 수 있습니다. 이 경우 회원은 고의, 과실이 없음을 입증하지 못하는 경우 책임을 면할 수 없습니다.
                제 14 조 (면책)
                  ① 회사는 다음 각 호의 경우로 서비스를 제공할 수 없는 경우 이로 인하여 회원에게 발생한 손해에 대해서는 책임을 부담하지 않습니다.
                    1. 천재지변 또는 이에 준하는 불가항력의 상태가 있는 경우
                    2. 서비스 제공을 위하여 회사와 서비스 제휴계약을 체결한 제3자의 고의적인 서비스 방해가 있는 경우
                    3. 회원의 귀책사유로 서비스 이용에 장애가 있는 경우
                    4. 제1호 내지 제3호를 제외한 기타 회사의 고의∙과실이 없는 사유로 인한 경우
                  ② 회사는 서비스 및 서비스에 게재된 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는 보증을 하지 않으며 이로 인해 발생한 회원의 손해에 대하여는 책임을 부담하지 아니합니다.
                제 15 조 (규정의 준용)
                  ① 본 약관은 대한민국법령에 의하여 규정되고 이행됩니다.
                  ② 본 약관에 규정되지 않은 사항에 대해서는 관련법령 및 상관습에 의합니다.
                제 16 조 (분쟁의 조정 및 기타)
                  ① 회사는 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 위치정보의 보호 및 이용 등에 관한 법률 제28조의 규정에 의한 방송통신위원회에 재정을 신청할 수 있습니다.
                  ② 회사 또는 고객은 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 개인정보보호법 제43조의 규정에 의한 개인정보분쟁조정위원회에 조정을 신청할 수 있습니다.
                제 17 조 (회사의 연락처)
                회사의 상호 및 주소 등은 다음과 같습니다.
                상 호 : 주식회사 TaekToy
                대 표 자 : 강 율 빈
                주 소 : 서울특별시 성동구 뚝섬로1길 31, 1303호
                이메일 : admin@UMATE.com
                부 칙
                  제1조 (시행일) 이 약관은 2021년 01월 01일부터 시행한다.
                  제2조 위치정보관리책임자는 2021년 01월을 기준으로 다음과 같이 지정합니다.
                이 름 : 황신택
                소 속 : TaekToy
                직 위 : 개발자
                연락처 : qwer123@gmail.com
                위치기반서비스 이용약관 버전번호 : v.3.0
                이전 위치기반서비스 이용약관 보기
    """
    



}