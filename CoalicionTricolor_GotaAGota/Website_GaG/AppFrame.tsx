import { NavLink, useLocation } from "react-router-dom";
import logoColor from "/Users/jimenagomezmatzui/Documents/Jimena/Prueba GaG/GaG_isaac /src/img/logoColor.png";
import { getAuth } from "firebase/auth";
import { useNavigate } from "react-router-dom";

type AppFrameProps = {
  body: JSX.Element;
};

const AppFrame = (props: AppFrameProps) => {
  const { body } = props;
  const location = useLocation().pathname;
  const navigate = useNavigate();

  const logOut = () => {
    const auth = getAuth();
    auth.signOut().then(() => {
      localStorage.clear();
      navigate("/");
    });
  };
/* 
ecosistema-innovacion-hidrica
problematicas-sustentables-hidricas
cartera-proyectos
espacio-we-work-digital
foro-creativo-intercambio-informacion
*/
  const renderHeader = () => {
    return (
      <header className="header_area">
        <div className="main_header_area animated">
          <div className="container">
            <div className="row">
              <div className="col-sm-1 col-xs-9">
                <div className="logo_area">
                  <a href="index.html">
                    <img src={logoColor} alt="Gota a Gota" />
                  </a>
                </div>
              </div>

              <div className="col-sm-11 col-xs-12">
                <div className="main_menu_area">
                  <div
                    className={`mainmenu ${
                      location === "/" ? "" : "black_menu"
                    }`}
                  >
                    <nav>
                      <ul id="nav">
                        <li>
                          <NavLink
                            className={({ isActive }) =>
                              isActive ? "" : ""
                            }
                            to="#"
                          >
                            Ecosistema de Innovación Hídrica CDMX
                          </NavLink>
                        </li>
                        <li>
                          <NavLink
                            className={({ isActive }) =>
                              isActive ? "" : ""
                            }
                            to="#"
                          >
                            Problemáticas
                          </NavLink>
                        </li>
                        <li>
                          <NavLink
                            className={({ isActive }) =>
                              isActive ? "" : ""
                            }
                            to="#"
                          >
                            Proyectos
                          </NavLink>
                        </li>
                        <li>
                          <NavLink
                            className={({ isActive }) =>
                              isActive ? "" : ""
                            }
                            to="#"
                          >
                            We Work
                          </NavLink>
                        </li>
                        <li>
                          <NavLink
                            className={({ isActive }) =>
                              isActive ? "" : ""
                            }
                            to="#"
                          >
                            Foro Creativo
                          </NavLink>
                        </li>
                        <li>
                          <NavLink
                            className={({ isActive }) =>
                              isActive ? "current_page_item" : ""
                            }
                            to="/perfil"
                          >
                            Mi Perfil
                          </NavLink>
                        </li>
                        <li>
                          <p onClick={() => logOut()}>Cerrar Sesión</p>
                        </li>
                      </ul>
                    </nav>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </header>
    );
  };

  const renderFooter = () => {
    return (
      <footer className="footer_area">
        <div className="footer_bottom_area">
          <div className="container">
            <div className="row">
              <div className="col-xs-12">
                <div className="social_links_area">
                  <a
                    href="http://www.linkedin.com/company/coalicion-tricolor"
                    target="_blank"
                    rel="noreferrer"
                    data-toggle="tooltip"
                    data-placement="top"
                    title="Linkedin"
                  >
                    <i className="icofont icofont-social-linkedin"></i>
                  </a>
                  <a
                    href="https://www.instagram.com/coaliciontricolor"
                    target="_blank"
                    rel="noreferrer"
                    data-toggle="tooltip"
                    data-placement="top"
                    title="Instagram"
                  >
                    <i className="icofont icofont-social-instagram"></i>
                  </a>
                  <a
                    href="https://www.youtube.com/channel/UCRbpNKRBUJ118D6LES7oyOw"
                    target="_blank"
                    rel="noreferrer"
                    data-toggle="tooltip"
                    data-placement="top"
                    title="Youtube"
                  >
                    <i className="icofont icofont-social-youtube-play"></i>
                  </a>
                </div>
              </div>
            </div>

            <div className="row">
              <div className="col-xs-12">
                <div className="footer_bottom">
                  <p>
                    Copyright &copy; {new Date().getFullYear()} Gota a Gota.
                  </p>
                  <p>
                    Proyecto de{" "}
                    <NavLink
                      to="https://www.coalicion-tricolor.com/"
                      target="_blank"
                    >
                      Coalición Tricolor
                    </NavLink>
                  </p>
                  <p>
                    Impulsado por{" "}
                    <NavLink
                      to="https://americas.makesense.org/"
                      target="_blank"
                    >
                      Makesense
                    </NavLink>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </footer>
    );
  };

  return (
    <>
      {renderHeader()}
      {body}
      {renderFooter()}
    </>
  );
};

export default AppFrame;
