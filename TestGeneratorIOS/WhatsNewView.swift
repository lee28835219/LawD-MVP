//
//  WhatsNewView.swift
//  TestGeneratorIOS
//
//  Created by Masterbuilder on 2023/09/08.
//  Copyright © 2023 MasterBuilder. All rights reserved.
//

import SwiftUI
import WebKit

// WKWebView를 사용하는 SwiftUI View 래퍼
struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct WhatsNewView: View {
    @State private var isAnimating = true // 앱 실행 시 한 번만 애니메이션 실행
    @State private var isWebViewVisible = false // 웹 뷰를 보여줄지 여부를 제어하는 상태 변수
    @State private var gonnaSubtextApperar = true

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("LawD")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
//                    .foregroundColor(.purple)
                    .scaleEffect(isAnimating ? 2 : 1.0)
                    .animation(Animation.easeInOut(duration: 2.0), value: isAnimating)
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                self.isAnimating = false
                            }
                        }
                    }
                // 로디 텍스트를 버튼으로 감싸고, 버튼을 누를 때 웹 뷰를 표시하도록 함
                    .onTapGesture {
                        isWebViewVisible = true
                    }
                if !gonnaSubtextApperar {
                    Text("이건민 변호사의 법학시험 데이터베이스")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .opacity(isAnimating ? 0.0 : 1.0)
                        .animation(Animation.easeInOut(duration: 1.0).delay(2.0), value: isAnimating)
                        
                    Spacer()
                }
            }

            Spacer()

            if !isAnimating && gonnaSubtextApperar {
                Text("이건민 변호사의 법학시험 데이터베이스")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity(isAnimating ? 0.0 : 1.0)
                    .animation(Animation.easeInOut(duration: 1.0).delay(2.0), value: isAnimating)
            }
            Spacer()
            // 버튼을 눌렀을 때 웹 뷰를 표시
            if isWebViewVisible {
                WebView(urlString: "https://mglaw.scourt.go.kr/wsjs/panre/sjs060.do?tabId=1")
                    .edgesIgnoringSafeArea(.all) // 화면 전체에 웹 뷰 표시
                    .onAppear() {
                        gonnaSubtextApperar = false
                    }
            }
        }
    }
}

                        
                    
                    // 추후 새소식카드로 만들어야 하는 뷰 2023. 9. 13. (-)
//                    VStack {
//                        Text("[최신판결]\n대법원 2023. 6. 29. 선고 2022도6278 판결")
//                            .font(.headline) // 폰트 크기와 스타일 설정
//                            .multilineTextAlignment(.center) // 중앙 정렬
//                            .padding(.horizontal) // 좌우 여백 추가
//
//                        Text("[아동·청소년의성보호에관한법률위반(음란물소지)·아동·청소년의성보호에관한법률위반(성착취물소지)]\n〈구「아동·청소년의 성보호에 관한 법률」제11조 제5항의 아동·청소년이용음란물 ‘소지’ 여부가 문제된 사건〉")
//                            .font(.subheadline) // 폰트 크기와 스타일 설정
//                            .multilineTextAlignment(.leading) // 중앙 정렬
//                            .padding(.horizontal) // 좌우 여백 추가
//
//                        Text("【판결요지】\n 형벌법규의 해석은 엄격하여야 하고 문언의 의미를 피고인에게 불리한 방향으로 지나치게 확장해석하는 것은 죄형법정주의 원칙에 어긋나는 것이다.\n 구 아동·청소년의 성보호에 관한 법률(2020. 6. 2. 법률 제17338호로 개정되기 전의 것) 제11조 제5항은 “아동·청소년이용음란물임을 알면서 이를 소지한 자는 1년 이하의 징역 또는 2천만 원 이하의 벌금에 처한다.”라고 규정하고 있다. 여기서 ‘소지’란 아동·청소년이용음란물을 자기가 지배할 수 있는 상태에 두고 지배관계를 지속시키는 행위를 말하고, 인터넷 주소(URL)는 인터넷에서 링크하고자 하는 웹페이지나 웹사이트 등의 서버에 저장된 개개의 영상물 등의 웹 위치 정보 또는 경로를 나타낸 것에 불과하다.\n 따라서 아동·청소년이용음란물 파일을 구입하여 시청할 수 있는 상태 또는 접근할 수 있는 상태만으로 곧바로 이를 소지로 보는 것은 소지에 대한 문언 해석의 한계를 넘어서는 것이어서 허용될 수 없으므로, 피고인이 자신이 지배하지 않는 서버 등에 저장된 아동·청소년이용음란물에 접근하여 다운로드받을 수 있는 인터넷 주소 등을 제공받은 것에 그친다면 특별한 사정이 없는 한 아동·청소년이용음란물을 ‘소지’한 것으로 평가하기는 어렵다.\n 한편 2020. 6. 2. 법률 제17338호로 개정된 아동·청소년의 성보호에 관한 법률 제11조 제5항은 아동·청소년성착취물을 구입하거나 시청한 사람을 처벌하는 규정을 신설하였고, 2020. 5. 19. 법률 제17264호로 개정된 성폭력범죄의 처벌 등에 관한 특례법 제14조 제4항은 카메라 등을 이용하여 성적 욕망 또는 수치심을 유발할 수 있는 사람의 신체를 촬영대상자의 의사에 반하여 촬영한 촬영물 또는 복제물을 소지·구입·저장 또는 시청한 사람을 처벌하는 규정을 신설하였다. 따라서 아동·청소년성착취물 등을 구입한 다음 직접 다운로드받을 수 있는 인터넷 주소를 제공받았다면 위 규정에 따라 처벌되므로 처벌공백의 문제도 더 이상 발생하지 않는다.")
//                            .font(.body) // 폰트 크기와 스타일 설정
//                            .multilineTextAlignment(.leading) // 중앙 정렬
//                            .padding(.horizontal) // 좌우 여백 추가
//                    }

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView()
    }
}
